require "rails/generators"

module Planter
  # Public: `rails generate planter:install`
  class InstallGenerator < Rails::Generators::Base
    desc "Create the default seed file and put in the plant folder."

    def create_default_seed_file
      create_file "db/sdfsdfdsfsd", "# Add initialization content here"
    end
  end
end
