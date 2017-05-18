$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "planter"
require "vcr"

def restore_default_config
  Planter.configuration = nil
  Planter.configure {}
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<github-access-token>") { "GITHUB-ACCESS-TOKEN" }
end
