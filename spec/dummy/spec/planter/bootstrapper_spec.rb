describe Planter::Bootstrapper do
  after { restore_default_config }

  before do
    Planter.configure do |config|
      config.github_access_token = "GITHUB-ACCESS-TOKEN"
      config.github_repository_full_name = "ableco/fino-test-repository"
    end
  end

  let(:default_plant_path) { "#{Rails.root}/db/plant/default.rb" }
  let(:issue_11_plant_path) { "#{Rails.root}/db/plant/issue_11.rb" }
  let(:issue_15_plant_path) { "#{Rails.root}/db/plant/issue_15.rb" }

  describe "#seed" do
    it "sets @seeding to true and calls #run" do
      expect(described_class).to receive(:run)
      described_class.seed
      expect(described_class.instance_variable_get(:@seeding)).to be(true)
    end
  end

  describe "#deseed" do
    it "sets @seeding to false and calls #run" do
      expect(described_class).to receive(:run)
      described_class.deseed
      expect(described_class.instance_variable_get(:@seeding)).to be(false)
    end
  end

  # The github_pull_request_for_planter cassette returns a
  # pull request that fixes issues 11 and 15.
  describe "#run", vcr: { cassette_name: "github_pull_request_for_planter" } do
    let(:stub_seed_class) do
      Class.new do
        def initialize(x); end

        def seed; end

        def deseed; end
      end
    end

    let(:plant_default_class_stub) { double("Plant::Default") }
    let(:issue_11_plant_class_stub) { double("Plant::Issue11") }
    let(:issue_15_plant_class_stub) { double("Plant::Issue15") }

    let(:default_plant_for_issue_11) { stub_seed_class.new(11) }
    let(:default_plant_for_issue_15) { stub_seed_class.new(15) }
    let(:issue_11_plant) { stub_seed_class.new(11) }
    let(:issue_15_plant) { stub_seed_class.new(15) }

    before do
      # Stub pull_request_number
      allow(Planter::QaEnvironment).to receive(:pull_request_number) { 1 }

      # Return true as if the file exists
      allow(described_class).to receive(:load_issue_specific_seed_file) { true }

      # Need to stub the `class` method otherwise we get an RSpec::Mocks::Double
      # class instead of the correct class in our specs.
      allow(plant_default_class_stub).to receive(:class) { plant_default_class_stub }
      allow(issue_11_plant_class_stub).to receive(:class) { issue_11_plant_class_stub }
      allow(issue_15_plant_class_stub).to receive(:class) { issue_15_plant_class_stub }

      # We need to stub the constants here because they don't exist until loaded
      # by the run method. As a result, unless we do this, rspec will return an
      # error because `Plant` doesn't exist yet.
      stub_const("Plant::Default", plant_default_class_stub)
      stub_const("Plant::Issue11", issue_11_plant_class_stub)
      stub_const("Plant::Issue15", issue_15_plant_class_stub)

      # Stub requires for the three classes
      allow(described_class).to receive(:require).with(default_plant_path) { true }
      allow(described_class).to receive(:require).with(issue_11_plant_path) { true }
      allow(described_class).to receive(:require).with(issue_15_plant_path) { true }

      # Stub instantiation of Plants
      allow(plant_default_class_stub).to receive(:new).with(11) { default_plant_for_issue_11 }
      allow(plant_default_class_stub).to receive(:new).with(15) { default_plant_for_issue_15 }
      allow(issue_11_plant_class_stub).to receive(:new).with(11) { issue_11_plant }
      allow(issue_15_plant_class_stub).to receive(:new).with(15) { issue_15_plant }
    end

    context "@seeding is true" do
      context "issue specific seed files exist" do
        it "loads the defaults and issue specific plants and calls #seed on them" do
          expect(default_plant_for_issue_11).to receive(:seed)
          expect(default_plant_for_issue_15).to receive(:seed)
          expect(issue_11_plant).to receive(:seed)
          expect(issue_15_plant).to receive(:seed)
          described_class.seed
        end
      end

      context "issue specific file is missing" do
        before do
          allow(described_class).to receive(:load_issue_specific_seed_file).and_call_original
          allow(described_class).to receive(:load_issue_specific_seed_file).with(11) { false }
        end

        it "calls seed on the default but not the issue specific plant" do
          expect(default_plant_for_issue_11).to receive(:seed)
          expect(issue_11_plant).to_not receive(:seed)
          described_class.seed
        end
      end
    end

    context "@seeding is false" do
      context "issue specific seed files exist" do
        it "loads the default seed file, instantiates it with the issue number, and calls #deseed on it" do
          expect(default_plant_for_issue_11).to receive(:deseed)
          expect(default_plant_for_issue_15).to receive(:deseed)
          expect(issue_11_plant).to receive(:deseed)
          expect(issue_15_plant).to receive(:deseed)
          described_class.deseed
        end
      end

      context "issue specific file is missing" do
        before do
          allow(described_class).to receive(:load_issue_specific_seed_file).and_call_original
          allow(described_class).to receive(:load_issue_specific_seed_file).with(11) { false }
        end

        it "calls seed on the default but not the issue specific plant" do
          expect(default_plant_for_issue_11).to receive(:deseed)
          expect(issue_11_plant).to_not receive(:deseed)
          described_class.deseed
        end
      end
    end
  end
end
