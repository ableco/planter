module Planter
  class PlantsController < ApplicationController
    def index
      @pull_request_number = Planter::QaEnvironment.pull_request_number
      @issue_numbers = Planter::QaEnvironment.issue_numbers
    end

    def reset

    end

    def seed
      issue_number = params[:plant_issue_number]
      Planter::Bootstrapper.run(issue_number)
    end
  end
end
