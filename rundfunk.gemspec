# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rundfunk/version'

Gem::Specification.new do |spec|
  spec.name          = 'rundfunk'
  spec.version       = Rundfunk::VERSION
  spec.authors       = ['Joe Corcoran']
  spec.email         = ['joe@corcoran.io']

  spec.summary       = %q{n/a}
  spec.description   = %q{n/a}
  spec.homepage      = 'http://github.com/joecorcoran/rundfunk'

  spec.files         = Dir['lib']
  spec.bindir        = 'bin'
  spec.executables   = ['rundfunk']
  spec.require_paths = ['lib']

  spec.add_dependency 'toml-rb', '~> 0.3'
  spec.add_dependency 'oga', '~> 2.7'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
