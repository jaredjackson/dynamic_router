# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamic_router/version'

Gem::Specification.new do |spec|
  spec.name          = "dynamic_router"
  spec.version       = DynamicRouter::VERSION
  spec.authors       = ["Gustavo Berdugo"]
  spec.email         = ["gberdugo@gmail.com"]
  spec.summary       = %q{Add dynamic routes to your project}
  spec.description   = %q{Use this gem to add dynamic routes to your project.}
  spec.homepage      = "https://github.com/coyosoftware/dynamic_router"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency('rails', '>= 4.0')
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  
end
