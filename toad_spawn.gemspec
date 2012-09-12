# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toad_spawn/version'

Gem::Specification.new do |s|
  s.name          = "toad_spawn"
  s.version       = ToadSpawn::VERSION
  s.authors       = ["Andy White"]
  s.email         = ["andy@wireworldmedia.co.uk"]
  s.description   = %q{A persistant, file based hash}
  s.summary       = %q{A basic persistent hash. Behaves similar to a normal hash but the key value
pairs persist between instantiations. The keys must be symbols and only 
strings, floats and fixnums can be stored as their original types, anything 
else is converted to a string. A simple file based store is used under the 
hood.}
  s.homepage      = ""
  
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 2.11.0"
end
