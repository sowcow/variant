# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'variant/version'

Gem::Specification.new do |spec|
  spec.name          = "variant"
  spec.version       = Variant::VERSION
  spec.authors       = ["Alexander K"]
  spec.email         = ["xpyro@ya.ru"]
  spec.description   = %q{ case/when using classes }.strip
  spec.summary       = %q{ case/when using classes }.strip
  spec.homepage      = "https://github.com/sowcow/variant"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
