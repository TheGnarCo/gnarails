lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gnarails/version"

Gem::Specification.new do |spec|
  spec.name          = "gnarails"
  spec.version       = Gnarails::VERSION
  spec.authors       = ["The Gnar Company"]
  spec.email         = ["hi@thegnar.co"]

  spec.summary       = "Easily create a gnarly rails app."
  spec.homepage      = "https://github.com/TheGnarCo/gnarails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.4"

  spec.add_dependency "rails", "~> 7.0.0"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", ">= 1.16", "< 3.0"
  spec.add_development_dependency "gnar-style"
  spec.add_development_dependency "pronto"
  spec.add_development_dependency "pronto-rubocop"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
