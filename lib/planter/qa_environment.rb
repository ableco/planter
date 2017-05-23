require "octokit"

module Planter
  # The review app
  class QaEnvironment
    class << self
      # Fetch a pull request object from GitHub based on a repository
      # name and pull request number.
      def pull_request(repository_full_name, pr_number)
        # Ensure that the pull request exists.
        client = Octokit::Client.new(access_token: Planter.configuration.github_access_token)
        client.pull_request(repository_full_name, pr_number)
      rescue Octokit::NotFound
        raise "Pull request ##{pr_number} for #{repository_full_name} was not found."
      end

      # Parse the pull request's body for the numbers of the issues being QA'd.
      def issue_numbers
        pull_request = pull_request(repository_full_name, pull_request_number)
        Planter::GithubIssueParser.new.parse_issue_numbers_from_pull_request_body(pull_request.body)
      end

      # Parse the pull request number from the HEROKU_APP_NAME.
      # Alternatively, a PULL_REQUEST_NUMBER can explicitly be set.
      def pull_request_number
        return ENV["PULL_REQUEST_NUMBER"] if ENV["PULL_REQUEST_NUMBER"]
        Planter.configuration.heroku_app_name.split("-pr-").last.to_i if Planter.configuration.heroku_app_name
      end

      # Checks that the GitHub repository full name has been set and then returns it.
      def repository_full_name
        full_name = Planter.configuration.github_repository_full_name
        unless full_name
          raise "The GitHub repository full name has not been set."
        end
        full_name
      end
    end
  end
end
