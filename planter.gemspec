$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "planter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "planter"
  s.version       = Planter::VERSION
  s.authors       = ["Able Engineering"]
  s.email         = ["engineering@able.co"]

  s.summary       = %q{Planter helps streamline the engineering and QA process for your Rails app by making it easy to create issue specific seed files for pull requests.}
  s.description   = %q{Planter helps streamline the engineering and QA process for your Rails app by making it easy to create issue specific seed files for pull requests.}
  s.homepage      = "https://github.com/ableco/planter"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.test_files = Dir["spec/**/*"]

  s.post_install_message = <<-MSG
Planter Setup - Local
===========================================================================
You can generate the default seed file and
folder by running the following command:

    bundle exec rails g planter:install

MSG

  s.add_runtime_dependency "octokit", "~> 4.7.0"

  s.add_development_dependency "rails", "~> 5.1.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec-rails", "~> 3.5.1"
  s.add_development_dependency "vcr", "~> 3.0.3"
  s.add_development_dependency "webmock", "1.24.6" # VCR currently breaks on webmock > 2.0
  s.add_development_dependency "generator_spec", "~> 0.9.3"
  s.add_development_dependency "byebug"
end
