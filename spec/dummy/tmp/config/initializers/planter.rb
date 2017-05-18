Planter.configure do |config|
  config.github_access_token =         ENV["GITHUB_ACCESS_TOKEN"]
  config.github_repository_full_name = ENV["GITHUB_REPOSITORY_FULLNAME"]
  config.heroku_app_name =             ENV["HEROKU_APP_NAME"]
end
