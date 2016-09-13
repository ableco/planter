require 'spec_helper'

describe Planter do
  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end

  describe "#configure" do
    after { restore_default_config }

    context "when attributes are specified" do
      let(:github_access_token) { "TEST-ACCESS-TOKEN" }
      let(:github_repository_full_name) { "ableco/planter" }
      let(:heroku_app_name) { "planter" }

      before :each do
        subject.configure do |config|
          config.github_access_token = github_access_token
          config.github_repository_full_name = github_repository_full_name
          config.heroku_app_name = heroku_app_name
        end
      end

      it "sets the github_access_token" do
        expect(subject.configuration.github_access_token).to eq(github_access_token)
      end

      it "sets the github_repository_full_name" do
        expect(subject.configuration.github_repository_full_name).to eq(github_repository_full_name)
      end

      it "sets the heroku_app_name" do
        expect(subject.configuration.heroku_app_name).to eq(heroku_app_name)
      end
    end

    context "when attributes are not specified" do
      it "sets the github_access_token to nil" do
        expect(subject.configuration.github_access_token).to eq(nil)
      end

      it "sets the github_repository_full_name to nil" do
        expect(subject.configuration.github_repository_full_name).to eq(nil)
      end

      it "sets the heroku_app_name to nil" do
        expect(subject.configuration.heroku_app_name).to eq(nil)
      end
    end
  end
end
