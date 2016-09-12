module Planter
  # Seed files should all inheirit from this Base class.
  class Base
    attr_reader :issue_number

    def initialize(issue_number)
      @issue_number = issue_number
    end

    def seed
      raise NotImplementedError
    end

    def deseed
      raise NotImplementedError
    end
  end
end
