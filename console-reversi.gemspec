# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'console_reversi/version'

Gem::Specification.new do |spec|
  spec.name          = "console-reversi"
  spec.version       = ConsoleReversi::VERSION
  spec.authors       = ["pekepek"]
  spec.email         = ["ishihata@33i.co.jp"]

  spec.summary       = %q{You can play the reversi in terminal}
  spec.description   = %q{You can play the reversi in terminal}
  spec.homepage      = "https://github.com/pekepek/console-reversi"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
