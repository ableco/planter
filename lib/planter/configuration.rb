module Planter
  class Configuration
    attr_accessor :github_access_token
    attr_accessor :github_repository_fullname
    attr_accessor :heroku_app_name

    def initialize
      @github_access_token = nil
      @github_repository_fullname = nil
      @heroku_app_name = nil
    end
  end
end
