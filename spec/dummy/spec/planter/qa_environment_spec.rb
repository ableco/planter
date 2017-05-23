describe Planter::QaEnvironment do
  after { restore_default_config }

  before do
    Planter.configure do |config|
      config.github_access_token = "GITHUB-ACCESS-TOKEN"
      config.github_repository_full_name = "ableco/fino-test-repository"
    end
  end

  describe "#pull_request" do
    context "pr is not found", vcr: { cassette_name: "github_pull_request_not_found" } do
      it "raises an error" do
        expect { described_class.send(:pull_request, "ableco/fino-test-repository", 111) }.to raise_error("Pull request #111 for ableco/fino-test-repository was not found.")
      end
    end
  end

  describe "#pull_request_number" do
    before do
      Planter.configure do |config|
        config.heroku_app_name = "fino-qa-staging-pr-5"
      end
    end

    context "PULL_REQUEST_NUMBER is defined" do
      before do
        allow(ENV).to receive(:[]).with("PULL_REQUEST_NUMBER") { 1 }
      end

      it "returns PULL_REQUEST_NUMBER" do
        expect(described_class.send(:pull_request_number)).to eq(1)
      end
    end

    context "PULL_REQUEST_NUMBER is NOT defined" do
      before do
        allow(ENV).to receive(:[]).with("PULL_REQUEST_NUMBER") { nil }
      end

      it "parses the pull request number from HEROKU_APP_NAME" do
        expect(described_class.send(:pull_request_number)).to eq(5)
      end
    end
  end

  describe "#repository_full_name" do
    context "GITHUB_REPOSITORY_FULLNAME exists" do
      it "returns the ENV variable" do
        expect(described_class.send(:repository_full_name)).to eq("ableco/fino-test-repository")
      end
    end

    context "GITHUB_REPOSITORY_FULLNAME does NOT exist" do
      before do
        Planter.configure do |config|
          config.github_repository_full_name = nil
        end
      end

      it "raises an error" do
        expect { described_class.send(:repository_full_name) }.to raise_error("The GitHub repository full name has not been set.")
      end
    end
  end
end
