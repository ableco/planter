require "rails/generators"

module Planter
  # Public: `rails generate planter:issue 1`
  class PlantGenerator < Rails::Generators::NamedBase
    desc "Create an issue seed file and put in db/plant."

    source_root File.expand_path("../../../../templates", __FILE__)

    def create_issue_seed_file
      copy_file "default.rb", "db/plant/issue_#{file_name}.rb"
    end
  end
end
