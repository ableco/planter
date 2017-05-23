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

      def capture_initial_application_state
        # TODO
        # Use sprig-reap? https://github.com/vigetlabs/sprig-reap
      end

      def restore_initial_application_state
        # TODO
      end

      # Calls `run` for each issue number associated with the QaEnvironment.
      def run_all(seeding: true)
        QaEnvironment.issue_numbers.each do |issue_number|
          run(issue_number: issue_number, seeding: seeding)
        end
      end

      # Accepts an issue number and boolean and runs the `seed` or
      # `deseed` method of the default plant file and the
      # plant file corresponding to the issue number.
      def run(issue_number:, seeding: true)
        run_default_plant(
          issue_number: issue_number,
          seeding: seeding
        )
        run_issue_specific_plant(
          issue_number: issue_number,
          seeding: seeding
        )
      end

      def run_default_plant(issue_number:, seeding: true)
        if defined?(Plant::Default) || load_default_plant_file
          default_seed = Plant::Default.new(issue_number)
          seeding ? default_seed.seed : default_seed.deseed
        end
      end

      def run_issue_specific_plant(issue_number:, seeding: true)
        if load_issue_specific_plant_file(issue_number)
          issue_seed = Plant.const_get("Issue#{issue_number}").new(issue_number)
          seeding ? issue_seed.seed : issue_seed.deseed
        end
      end

      def load_default_plant_file
        require "#{Rails.root}/db/plant/default.rb"
      rescue LoadError
        false
      end

      def load_issue_specific_plant_file(issue_number)
        require "#{Rails.root}/db/plant/issue_#{issue_number}.rb"
      rescue LoadError
        false
      end
    end
  end
end
