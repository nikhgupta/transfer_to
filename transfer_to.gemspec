$:.push File.expand_path("../lib", __FILE__)
require 'transfer_to/version'

Gem::Specification.new do |gem|
  gem.name          = "transfer_to"
  gem.version       = TransferTo::VERSION
  gem.authors       = ['Nikhil Gupta', 'L. Doubrava']
  gem.email         = ['me@nikhgupta.com']
  gem.description   = %q{Consumes TransferTo.com API and provides with ruby methods for the same}
  gem.summary       = %q{Gem to consume TransferTo.com API}
  gem.homepage      = 'http://rubygems.org/gems/transfer_to'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'faraday'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency('rake', ['>= 0'])
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'pry-byebug'
  gem.add_development_dependency('rspec', ['>= 0'])
end
