require 'qu/backend/mongoid'

module Qu

  if !!defined?(BSON)
    def self.bson_from_time(time, opts={})
      unique = opts.fetch(:unique, false)
      if unique
        Moped::BSON::ObjectId.from_string(BSON::ObjectId.from_time(time, unique: true).to_s)
      else
        Moped::BSON::ObjectId.from_time(time)
      end
    end
  else
    warn "WARNING: 10gen BSON not available, unique id's from time not possible!"
    def self.bson_from_time(time, opts={})
      unique = opts.fetch(:unique, false)
      if unique
        warn "WARNING: 10gen BSON not available, unique id's from time not possible!"
        Moped::BSON::ObjectId.from_time(time)
      else
        Moped::BSON::ObjectId.from_time(time)
      end
    end
  end

  module Delayed
    module Backend
      module Mongoid
        def enqueue_at(payload)
          payload_id = Qu.bson_from_time(payload.run_at, unique: true)#Moped::BSON::ObjectId.from_time(payload.run_at)#, :unique => true) # not sure if this can cause problems
          delayed_jobs.insert({
                                :_id => payload_id,
                                :klass => payload.klass.to_s,
                                :queue => payload.queue,
                                :args => payload.args
                              })
          logger.debug { "Enqueued delayed job #{payload}" }
          payload
        end

        # Retrieves next delayed job.
        #
        # If there is no job to enqueue returns +nil+.
        def next_delayed_job
          doc = connection.command(:findAndModify => delayed_jobs.name, :query => {:_id => {'$lte' => Qu.bson_from_time(Time.now) }}, :remove => true, :safe => true)
          return nil unless doc && doc['value']
          doc = doc['value']

          Qu::Delayed::Payload.new(doc).undelay
        rescue ::Moped::Errors::OperationFailure
          nil
        end

        def delayed_jobs
          self[:delayed_jobs]
        end

        def clear_delayed
          logger.info { "Clearing delayed jobs queue" }
          delayed_jobs.drop
        end
      end
    end
  end
end

Qu::Backend::Mongoid.send :include, Qu::Delayed::Backend::Mongoid
