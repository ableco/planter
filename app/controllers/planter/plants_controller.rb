module Planter
  class PlantsController < ApplicationController
    def index
      @pull_request_number = Planter::QaEnvironment.pull_request_number
      @issue_numbers = Planter::QaEnvironment.issue_numbers
    end

    # /planter/:plant_issue_number/seed
    # Run the `seed` method for the given issue number's plant file.
    def seed
      Planter::Bootstrapper.run(
        issue_number: params[:plant_issue_number],
        seeding: true
      )
      redirect_to :back
    end

    # /planter/:plant_issue_number/deseed
    # Run the `deseed` method for the given issue number's plant file.
    def Deseed
      Planter::Bootstrapper.run(
        issue_number: params[:plant_issue_number],
        seeding: false
      )
      redirect_to :back
    end

    # /planter/reset
    # Resets the review app's application state to what it was at deployment.
    def reset
      Planter::Bootstrapper.restore_initial_application_state
      redirect :back
    end
  end
end
