module Planter
  class Engine < ::Rails::Engine
    isolate_namespace Planter

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
