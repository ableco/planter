module Planter
  # Public: Collection of helpers to read structured plaintext from GitHub and
  # return structured data.
  class GithubIssueParser
    # GitHub keywords we support https://help.github.com/articles/closing-issues-via-commit-messages/
    SUPPORTED_KEYWORDS = %w(close closes closed fix fixes fixed resolve resolves resolved).freeze

    # Returns the issue numbers found in the pull request description.
    # The numbers are sorted so that seed files are loaded in a predictable order.
    def parse_issue_numbers_from_pull_request_body(pull_request_body)
      pull_request_body.scan(/(#{SUPPORTED_KEYWORDS.join("|")}) #(\d+)/i).map { |x| x.last.to_i }.sort
    end
  end
end
