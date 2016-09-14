require "rails/generators"

module Planter
  # Public: `rails generate planter:install`
  class InstallGenerator < Rails::Generators::Base
    desc "Create the default seed file and put in the plant folder."

    source_root File.expand_path("../../../../templates", __FILE__)

    def create_default_seed_file
      copy_file "default.rb", "db/dsfdsfdsfds/default.rb"
    end
  end
end
