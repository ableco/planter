require "rails/generators"

# Public: `rails generate planter:install`
class InstallGenerator < Rails::Generators::Base
  desc "Create the default.rb seed file and put it in db/plant."

  source_root File.expand_path("../../../../templates", __FILE__)

  def create_default_seed_file
    copy_file "db/plant/default.rb", "db/plant/default.rb"
    copy_file "config/initializers/planter.rb", "config/initializers/planter.rb"
  end
end

# module Planter
#   # Public: `rails generate planter:install`
#   class InstallGenerator < Rails::Generators::Base
#     desc "Create the default.rb seed file and put it in db/plant."
#
#     source_root File.expand_path("../../../../templates", __FILE__)
#
#     def create_default_seed_file
#       copy_file "db/plant/default.rb", "db/plant/default.rb"
#       copy_file "config/initializers/planter.rb", "config/initializers/planter.rb"
#     end
#   end
# end
