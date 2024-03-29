# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pando/version'

Gem::Specification.new do |spec|
  spec.name          = "pando"
  spec.version       = Pando::VERSION
  spec.authors       = ["Garrett Thornburg"]
  spec.email         = ["film42@gmail.com"]
  spec.summary       = %q{A generic service directory gem that uses zookeeper.}
  spec.description   = %q{A generic service directory gem that uses zookeeper.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "zk"
end
