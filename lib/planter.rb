require "planter/version"
require "planter/configuration"
require "planter/base"
require "planter/github_issue_parser"
require "planter/bootstrapper"
require "planter/railtie" if defined?(Rails)
require "octokit"

module Planter
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
