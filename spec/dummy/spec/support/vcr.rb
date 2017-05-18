require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/vcr_cassettes")
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<github-access-token>") { "GITHUB-ACCESS-TOKEN" }
end
