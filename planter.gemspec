# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'planter/version'

Gem::Specification.new do |spec|
  spec.name          = "planter"
  spec.version       = Planter::VERSION
  spec.authors       = ["Able Engineering"]
  spec.email         = ["engineering@able.co"]

  spec.summary       = %q{Planter helps streamline QA on your Rails apps by making it easy to create issue specific seed files for your pull requests.}
  spec.description   = %q{Planter helps streamline QA on your Rails apps by making it easy to create issue specific seed files for your pull requests.}
  spec.homepage      = "https://github.com/ableco/planter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.post_install_message = <<-MSG
Planter Setup - Local
===========================================================================
You can generate the default seed file and
folder by running the following command:

    bundle exec rails g planter:install

MSG

  spec.add_runtime_dependency "octokit", "~> 4.3.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "webmock", "1.24.6" # VCR currently breaks on webmock > 2.0
  spec.add_development_dependency "byebug"
end
