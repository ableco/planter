module Plant
  # This seed gets run with every issue.
  class Default < Planter::Base
    def seed
      # Add actions that you want to be run for every issue here.
    end

    def deseed
      # Add actions that you want to be run after every review app is destroyed here.
    end
  end
end
