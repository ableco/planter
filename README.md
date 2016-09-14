# Planter

Planter helps streamline QA on your Rails apps by making it easy to create issue specific seed files for your pull requests.

## Requirements

- A Rails app with the Planter gem installed
- GitHub issues for issue tracking
- The app needs to be deployed to Heroku
- The app needs to use Heroku review apps with the `buildpack-ruby-rake-deploy-tasks` buildpack

## Installation

Add this line to your application's Gemfile:

```ruby
gem "planter", git: "https://github.com/ableco/planter.git"
```

And then execute:

    $ bundle install
    $ rails generate planter:install

Configure Planter using environment variables and the following initializer:

```ruby
Planter.configure do |config|
  config.github_access_token         = ENV["GITHUB_ACCESS_TOKEN"]
  config.github_repository_full_name = ENV["GITHUB_REPOSITORY_FULLNAME"]
  config.heroku_app_name             = ENV["HEROKU_APP_NAME"]
end
```

Your Heroku review apps need to be configured to run the Planter rake tasks after deploy
and before destroy. This can be accomplished by updating your `app.json` file to use
the `buildpack-ruby-rake-deploy-tasks` custom buildpack. Here's an example `app.json` file:

```json
{
  "name": "Planter",
  "website": "https://github.com/ableco/planter",
  "repository": "https://github.com/ableco/planter",
  "scripts": {
    "pr-predestroy": "bundle exec rake planter:deseed"
  },
  "env": {
    "GITHUB_ACCESS_TOKEN": {
      "required": true
    },
    "GITHUB_REPOSITORY_FULLNAME": {
      "required": true
    },
    "HEROKU_APP_NAME": {
      "required": true
    },
    "DISABLE_DATABASE_ENVIRONMENT_CHECK": "1",
    "DEPLOY_TASKS": "db:schema:load db:seed planter:seed RAILS_ENV=production"
  },
  "buildpacks": [
    {
      "url": "https://github.com/heroku/heroku-buildpack-ruby.git"
    },
    {
      "url": "https://github.com/ableco/buildpack-ruby-rake-deploy-tasks"
    }
  ]
}
```
