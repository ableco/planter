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
  end
end
