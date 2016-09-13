module Planter
  class Configuration
    # The GitHub access token that will be used to make
    # requests to the GitHub API via the Octokit gem.
    attr_accessor :github_access_token

    # The full name of the GitHub repository where the pull requests
    # that Planter will be looking at can be found.
    attr_accessor :github_repository_full_name

    # The name of the application on Heroku that is the parent of
    # the review apps that Planter will be seeding.
    attr_accessor :heroku_app_name

    def initialize
      @github_access_token = nil
      @github_repository_full_name = nil
      @heroku_app_name = nil
    end
  end
end
