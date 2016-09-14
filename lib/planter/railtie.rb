require "planter"
require "rails"

module Planter
  # :NODOC:
  class Railtie < Rails::Railtie
    railtie_name :planter

    # Public: Expose our rake tasks to the Rails application.
    rake_tasks do
      load "planter/tasks/planter.rake"
    end

    # Public: Expose generators to application's `rails generate`
    generators do
      require "planter/generators/install_generator"
      require "planter/generators/plant_generator"
    end
  end
end
