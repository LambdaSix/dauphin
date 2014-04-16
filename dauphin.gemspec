# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dauphin/version'

Gem::Specification.new do |spec|
  spec.name          = 'dauphin'
  spec.version       = Dauphin::VERSION
  spec.authors       = ['LambdaSix']
  spec.email         = ['alexander.somerville.cox@gmail.com']
  spec.summary       = 'Library for accessing the Prince XML 9 command line tool'
  spec.description   = 'Provides a nice wrapper around the command line tool invocation'
  spec.homepage      = 'http://github.com/LambdaSix/dauphin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec', '~> 2', '>= 2.14.1'
  spec.add_development_dependency 'rake'
end
