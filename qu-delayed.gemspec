# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qu-delayed/version'

Gem::Specification.new do |gem|
  gem.name          = "qu-delayed"
  gem.version       = Qu::Delayed::VERSION
  gem.authors       = ["Viacheslav Molokov", "John Axel Eriksson"]
  gem.date          = "2012-11-27"
  gem.email         = ["viacheslav.molokov@gmail.com"]
  gem.description   = %q{Qu::Delayed is basic scheduler for Qu queue system.}
  gem.summary       = %q{Qu::Delayed is basic scheduler for Qu queue system.}
  gem.homepage      = "http://github.com/imomoisoft/qu-delayed"
  gem.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency("moped", [">= 1.4.0"])


  gem.add_runtime_dependency("qu", ["= 0.1.4"])
  gem.add_development_dependency("rspec", ["~> 2.8.0"])
  gem.add_development_dependency("rdoc", ["~> 3.12"])
  gem.add_development_dependency("bundler", ["~> 1.2.0"])
  gem.add_development_dependency("timecop", [">= 0"])
  gem.add_development_dependency("spork", [">= 0"])
  gem.add_development_dependency("guard", [">= 0"])
  gem.add_development_dependency("guard-rspec", [">= 0"])
  gem.add_development_dependency("guard-spork", [">= 0"])
  gem.add_development_dependency("qu-mongo", [">= 0"])
  gem.add_development_dependency("qu-mongoid", [">= 0"])

end
