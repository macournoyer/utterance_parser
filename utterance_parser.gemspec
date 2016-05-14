# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utterance_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "utterance_parser"
  spec.version       = UtteranceParser::VERSION
  spec.authors       = ["Marc-Andre Cournoyer"]
  spec.email         = ["macournoyer@gmail.com"]
  spec.summary       = "Extract intent and entities from natural language utterances"
  spec.description   = "A trainable natural language parser that extracts intent and entities from utterances."
  spec.homepage      = "https://github.com/macournoyer/utterance_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'engtagger', '~> 0.2'
  spec.add_dependency 'nbayes', '~> 0.1'
  spec.add_dependency 'wapiti', '~> 0.1'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
