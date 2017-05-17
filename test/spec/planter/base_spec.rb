require 'spec_helper'

describe Planter::Base do
  describe "issue_number" do
    let(:base) { described_class.new(12345) }

    it "can be initialized with an issue number" do
      expect(base.issue_number).to eq(12345)
    end
  end
end
