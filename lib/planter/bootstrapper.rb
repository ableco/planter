require "octokit"

module Planter
  # Bootstrapping qa data.
  class Bootstrapper
    class << self
      # Run the `seed` method for all of the associated plant files.
      def seed
        run_all(seeding: true)
      end

      # Run the `deseed` method for all of the associated plant files.
      # "Deseed" is a real word: http://www.merriam-webster.com/dictionary/deseed
      def deseed
        run_all(seeding: false)
      end

      # Accepts an issue number and boolean and runs the `seed` or `deseed`
      # method of the plant file corresponding to the issue number.
      def run(issue_number:, seeding:)
        if defined?(Plant::Default) || load_default_seed_file
          default_seed = Plant::Default.new(issue_number)
          seeding ? default_seed.seed : default_seed.deseed
        end

        if load_issue_specific_seed_file(issue_number)
          issue_seed = Plant.const_get("Issue#{issue_number}").new(issue_number)
          seeding ? issue_seed.seed : issue_seed.deseed
        end
      end

      # Calls `run` for each issue number associated with the QaEnvironment.
      def run_all(seeding:)
        QaEnvironment.issue_numbers.each do |issue_number|
          run(issue_number: issue_number, seeding: seeding)
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
    end
  end
end
