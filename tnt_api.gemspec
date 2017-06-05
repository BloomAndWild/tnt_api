# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tnt_api/version'

Gem::Specification.new do |spec|
  spec.name          = "tnt_api"
  spec.version       = TNTApi::VERSION
  spec.authors       = ["Gediminas"]
  spec.email         = ["gediminas@bloomandwild.com"]

  spec.summary       = %q{ruby wrapper for TNT API}
  spec.description   = %q{ruby wrapper for TNT API}
  spec.homepage      = ""

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_dependency "savon", "~> 2.10"
  spec.add_dependency "httpclient", "~> 2.3"
  spec.add_development_dependency "dotenv", "~> 2.0"
  spec.add_dependency "activesupport", ">= 4"

  # Testing
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.21"
  spec.add_development_dependency "vcr", "~> 3"
end
