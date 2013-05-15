# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jabot/version'

Gem::Specification.new do |gem|
	gem.name          = 'jabot'
	gem.version       = Jabot::VERSION
	gem.authors       = ['Andrey Skat']
	gem.email         = %w{andrey2004@gmail.com}
	gem.description   = %q{Jabber bot with DSL}
	#gem.summary       = %q{Jabber bot with DSL}
	gem.homepage      = 'https://github.com/andrey-skat/jabot'

	#gem.files         = `git ls-files`.split($/)
	gem.files         = Dir['lib/**/*']
	gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
	gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
	gem.require_paths = %w{lib}

	gem.add_runtime_dependency 'xmpp4r'

	gem.add_development_dependency 'rake'
	gem.add_development_dependency 'rspec'
end