$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "planter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  spec.name          = "planter"
  spec.version       = Planter::VERSION
  spec.authors       = ["Able Engineering"]
  spec.email         = ["engineering@able.co"]

  spec.summary       = %q{Planter helps streamline the engineering and QA process for your Rails app by making it easy to create issue specific seed files for pull requests.}
  spec.description   = %q{Planter helps streamline the engineering and QA process for your Rails app by making it easy to create issue specific seed files for pull requests.}
  spec.homepage      = "https://github.com/ableco/planter"
  spec.license       = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.post_install_message = <<-MSG
Planter Setup - Local
===========================================================================
You can generate the default seed file and
folder by running the following command:

    bundle exec rails g planter:install

MSG

  spec.add_runtime_dependency "octokit", "~> 4.7.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "webmock", "1.24.6" # VCR currently breaks on webmock > 2.0
  spec.add_development_dependency "generator_spec", "~> 0.9.3"
  spec.add_development_dependency "byebug"
end
