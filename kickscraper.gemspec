# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kickscraper/version'

Gem::Specification.new do |spec|
  spec.name          = "kickscraper"
  spec.version       = Kickscraper::VERSION
  spec.authors       = ["Mark Olson", "Ben Rugg", "James Allen", "Mark Anderson"]
  spec.email         = ["theothermarkolson@gmail.com"]
  spec.description   = %q{Interact with Kickstarter through their API}
  spec.summary       = %q{API library for Kickstarter}
  spec.homepage      = "https://github.com/markolson/kickscraper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core", "~> 2.14"

  spec.add_runtime_dependency('faraday', ['>= 0.7', '< 0.9'])
  spec.add_runtime_dependency('faraday_middleware', '~> 0.8')
  spec.add_runtime_dependency('multi_json', '>= 1.0.3', '~> 1.0')
  spec.add_runtime_dependency('hashie',  '~> 2')
  spec.add_runtime_dependency('uri-query_params', '~>0.7.1')

end
