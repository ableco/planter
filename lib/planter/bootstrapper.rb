require "octokit"

module Planter
  # Bootstrapping qa data.
  class Bootstrapper
    class << self
      def seed
        @seeding = true
        run
      end

      # "Deseed" is a real word: http://www.merriam-webster.com/dictionary/deseed
      def deseed
        @seeding = false
        run
      end

      def run
        QaEnvironment.issue_numbers.each do |issue_number|
          if defined?(Plant::Default) || load_default_seed_file
            default_seed = Plant::Default.new(issue_number)
            seeding? ? default_seed.seed : default_seed.deseed
          end

          next unless load_issue_specific_seed_file(issue_number)
          issue_seed = Plant.const_get("Issue#{issue_number}").new(issue_number)
          seeding? ? issue_seed.seed : issue_seed.deseed
        end
      end

      def load_default_seed_file
        require "#{Rails.root}/db/plant/default.rb"
      rescue LoadError
        false
      end

      def load_issue_specific_seed_file(issue_number)
        require "#{Rails.root}/db/plant/issue_#{issue_number}.rb"
      rescue LoadError
        false
      end

      def seeding?
        @seeding
      end
    end
  end
end
