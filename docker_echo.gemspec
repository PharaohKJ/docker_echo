# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_echo/version'

Gem::Specification.new do |spec|
  spec.name          = "docker_echo"
  spec.version       = DockerEcho::VERSION
  spec.authors       = ["Tomokazu Kiyohara"]
  spec.email         = ["tomokazu.kiyohara@gmail.com"]
  spec.summary       = "docker echo service's manager"
  spec.description   = "docker echo service's manager"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'serverengine'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'puma'
  spec.add_runtime_dependency 'grape'

  spec.add_runtime_dependency 'docker-api'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry'
end
