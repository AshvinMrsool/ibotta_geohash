# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ibotta_geohash/version'

Gem::Specification.new do |spec|
  spec.name          = "ibotta_geohash"
  spec.version       = IbottaGeohash::VERSION
  spec.authors       = ["Justin Hart", "Yuichiro MASUI", "kazuki.kuriyama"]
  spec.email         = ["jhart@onyxraven.com"]

  spec.summary       = %q{Pure Ruby Geohash}
  spec.description   = %q{Geohash methods originally written by @masuidrive, with fixes and additions}
  spec.homepage      = "https://github.com/Ibotta/ibotta_geohash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
