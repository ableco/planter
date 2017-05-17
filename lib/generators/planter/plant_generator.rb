require "rails/generators"

module Planter
  # Public: `rails generate planter:plant 1`
  class PlantGenerator < Rails::Generators::NamedBase
    desc "Create an issue specific seed file and put it in db/plant."

    source_root File.expand_path("../../../../templates", __FILE__)

    def create_issue_seed_file
      seed_file_name = "db/plant/issue_#{file_name}.rb"
      copy_file "db/plant/issue_template.rb", seed_file_name
      gsub_file seed_file_name, /Issue/, "Issue#{file_name}"
    end
  end
end
