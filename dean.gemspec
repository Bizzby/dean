# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dean/version'

Gem::Specification.new do |spec|
  spec.name          = "dean"
  spec.version       = Dean::VERSION
  spec.authors       = ["Gio"]
  spec.email         = ["giovanni.lodi42@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'shenzhen', '~> 0.5.4'
  spec.add_dependency 'plist', '~> 3.1.0'
  spec.add_dependency 'aws-sdk', '~> 1.31.3'
  spec.add_dependency 'colorize', '~> 0.7.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
