require "generator_spec"
require "generators/planter/plant_generator"

describe Planter::PlantGenerator, type: :generator do
  destination File.expand_path("../../../tmp", File.dirname(__FILE__))
  arguments %w(42)

  context "file generation" do
    let(:expected_file_path) { "db/plant/issue_42.rb" }
    let(:new_issue_seed_file) { File.expand_path(expected_file_path, destination_root) }

    before(:all) do
      prepare_destination
      run_generator
    end

    it "copies the issue seed file template and names it based on to the number given" do
      assert_file(expected_file_path)
    end

    it "updates the class name in the file" do
      expect(File.read(new_issue_seed_file)).to include("class Issue42 < Planter::Base")
    end
  end
end
