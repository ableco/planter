describe Planter::Bootstrapper do
  after { restore_default_config }

  before do
    Planter.configure do |config|
      config.github_access_token = "GITHUB-ACCESS-TOKEN"
      config.github_repository_full_name = "ableco/fino-test-repository"
    end
  end

  let(:default_plant_path) { "#{Rails.root}/db/plant/default.rb" }
  let(:issue_42_plant_path) { "#{Rails.root}/db/plant/issue_42.rb" }

  describe "#seed" do
    it "calls #run_all and passes a true value for `seeding`" do
      expect(described_class).to receive(:run_all).with(seeding: true)
      described_class.seed
    end
  end

  describe "#deseed" do
    it "calls #run_all and passes a false value for `seeding`" do
      expect(described_class).to receive(:run_all).with(seeding: false)
      described_class.deseed
    end
  end

  describe "#run" do
    let(:stub_seed_class) do
      Class.new do
        def initialize(x); end

        def seed; end

        def deseed; end
      end
    end

    let(:plant_default_class_stub) { double("Plant::Default") }
    let(:issue_42_plant_class_stub) { double("Plant::Issue42") }

    let(:default_plant_for_issue_42) { stub_seed_class.new(42) }
    let(:issue_42_plant) { stub_seed_class.new(42) }

    before do
      # Return true as if the file exists
      allow(described_class).to receive(:load_issue_specific_seed_file) { true }

      # Need to stub the `class` method otherwise we get an RSpec::Mocks::Double
      # class instead of the correct class in our specs.
      allow(plant_default_class_stub).to receive(:class) { plant_default_class_stub }
      allow(issue_42_plant_class_stub).to receive(:class) { issue_11_plant_class_stub }

      # We need to stub the constants here because they don't exist until loaded
      # by the run method. As a result, unless we do this, rspec will return an
      # error because `Plant` doesn't exist yet.
      stub_const("Plant::Default", plant_default_class_stub)
      stub_const("Plant::Issue42", issue_42_plant_class_stub)

      # Stub requires for the three classes
      allow(described_class).to receive(:require).with(default_plant_path) { true }
      allow(described_class).to receive(:require).with(issue_42_plant_path) { true }

      # Stub instantiation of Plants
      allow(plant_default_class_stub).to receive(:new).with(42) { default_plant_for_issue_42 }
      allow(issue_42_plant_class_stub).to receive(:new).with(42) { issue_42_plant }
    end

    context "seeding is true" do
      context "issue specific seed files exist" do
        it "loads the defaults and issue specific plants and calls #seed on them" do
          expect(default_plant_for_issue_42).to receive(:seed)
          expect(issue_42_plant).to receive(:seed)
          described_class.run(issue_number: 42, seeding: true)
        end
      end

      context "issue specific file is missing" do
        before do
          allow(described_class).to receive(:load_issue_specific_seed_file).and_call_original
          allow(described_class).to receive(:load_issue_specific_seed_file).with(42) { false }
        end

        it "calls seed on the default but not the issue specific plant" do
          expect(default_plant_for_issue_42).to receive(:seed)
          expect(issue_42_plant).to_not receive(:seed)
          described_class.run(issue_number: 42, seeding: true)
        end
      end
    end

    context "seeding is not specified" do
      context "issue specific seed files exist" do
        it "loads the defaults and issue specific plants and calls #seed on them" do
          expect(default_plant_for_issue_42).to receive(:seed)
          expect(issue_42_plant).to receive(:seed)
          described_class.run(issue_number: 42)
        end
      end

      context "issue specific file is missing" do
        before do
          allow(described_class).to receive(:load_issue_specific_seed_file).and_call_original
          allow(described_class).to receive(:load_issue_specific_seed_file).with(42) { false }
        end

        it "calls seed on the default but not the issue specific plant" do
          expect(default_plant_for_issue_42).to receive(:seed)
          expect(issue_42_plant).to_not receive(:seed)
          described_class.run(issue_number: 42)
        end
      end
    end

    context "seeding is false" do
      context "issue specific seed files exist" do
        it "loads the default seed file, instantiates it with the issue number, and calls #deseed on it" do
          expect(default_plant_for_issue_42).to receive(:deseed)
          expect(issue_42_plant).to receive(:deseed)
          described_class.run(issue_number: 42, seeding: false)
        end
      end

      context "issue specific file is missing" do
        before do
          allow(described_class).to receive(:load_issue_specific_seed_file).and_call_original
          allow(described_class).to receive(:load_issue_specific_seed_file).with(42) { false }
        end

        it "calls seed on the default but not the issue specific plant" do
          expect(default_plant_for_issue_42).to receive(:deseed)
          expect(issue_42_plant).to_not receive(:deseed)
          described_class.run(issue_number: 42, seeding: false)
        end
      end
    end
  end

  # The github_pull_request_for_planter cassette returns a
  # pull request that fixes issues 11 and 15.
  describe "#run_all", vcr: { cassette_name: "github_pull_request_for_planter" } do
    before do
      # Stub pull_request_number
      allow(Planter::QaEnvironment).to receive(:pull_request_number) { 1 }
    end

    context "seeding is true" do
      it "iterates through the PR passing the issue number and `seeding: true` to `#run`" do
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 11, seeding: true)
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 15, seeding: true)
        described_class.run_all(seeding: true)
      end
    end

    context "seeding is not specified" do
      it "iterates through the PR passing the issue number and `seeding: true` to `#run`" do
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 11, seeding: true)
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 15, seeding: true)
        described_class.run_all
      end
    end

    context "seeding is false" do
      it "iterates through the PR passing the issue number and `seeding: false` to `#run`" do
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 11, seeding: false)
        expect(Planter::Bootstrapper).to receive(:run).with(issue_number: 15, seeding: false)
        described_class.run_all(seeding: false)
      end
    end
  end
end
