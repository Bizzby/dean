# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dean/version'

Gem::Specification.new do |spec|
  spec.name          = "dean"
  spec.version       = Dean::VERSION
  spec.authors       = ["Giovanni Lodi"]
  spec.email         = ["giovanni.lodi42@gmail.com"]
  spec.description   = %q{An (opinionated) CLI tool to ease mundane tasks of the iOS beta distribution}
  spec.summary       = %q{An (opinionated) CLI tool to ease mundane tasks of the iOS beta distribution, such as version bumps, archiving, and deploying, all configured in a simple unique file.}
  spec.homepage      = "https://github.com/bizzby/dean"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.17.0'
  spec.add_dependency 'shenzhen', '~> 0.6'
  spec.add_dependency 'plist', '~> 3.1.0'
  # shenzhen already adds dependency to aws-sdk
  # spec.add_dependency 'aws-sdk', '~> 1.31.3'
  spec.add_dependency 'colorize', '~> 0.7.0'
  spec.add_dependency 'semantic', '~> 1.3.0'
  spec.add_dependency 'xcodeproj', '~> 0.16.1'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
