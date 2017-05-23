module Planter
  module PlantsHelper
    def pull_request_url(pull_request_number)
      "https://github.com/#{Planter.configuration.github_repository_full_name}/pulls/#{pull_request_number}"
    end

    def issue_url(issue_number)
      "https://github.com/#{Planter.configuration.github_repository_full_name}/issues/#{issue_number}"
    end
  end
end
