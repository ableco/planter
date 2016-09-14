require "generator_spec"
require "planter/generators/install_generator"

describe Planter::InstallGenerator, type: :generator do
  destination File.expand_path("../../../../tmp", File.dirname(__FILE__))

  context "file generation" do
    before(:all) do
      prepare_destination
      run_generator
    end

    it "copies the default plant file" do
      assert_file "db/plant/default.rb"
    end

    it "copies the planter initializer file" do
      assert_file "config/initializers/planter.rb"
    end
  end
end
