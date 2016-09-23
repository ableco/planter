# Planter

Planter helps streamline QA on your Rails apps by making it easy to create issue specific seed files for your pull requests.

## Requirements

- A Rails app with the Planter gem installed
- GitHub issues for issue tracking
- An app deployed to Heroku

## Usage

Generate an issue specific seed file using the issue number:

    $ rails generate planter:plant 42

That command will generate an issue specific seed file for GitHub issue #42.

The file can be found and edited at `db/plant/issue_42.rb`.

When a pull request that closes issue #42 is deployed as a Heroku review app,
that seed file will be used to seed the database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "planter", git: "https://github.com/ableco/planter.git", tag: "v0.1.1"
```

And then execute:

    $ bundle install
    $ rails generate planter:install

The Planter install script will create a `db/plant` folder with a default seed
file. It will also generate the following initializer file:

```ruby
Planter.configure do |config|
  config.github_access_token         = ENV["GITHUB_ACCESS_TOKEN"]
  config.github_repository_full_name = ENV["GITHUB_REPOSITORY_FULL_NAME"]
  config.heroku_app_name             = ENV["HEROKU_APP_NAME"]
end
```

`HEROKU_APP_NAME` is automatically set but you will need to define `GITHUB_ACCESS_TOKEN`
and `GITHUB_REPOSITORY_FULL_NAME` in [the Heroku config yourself](https://devcenter.heroku.com/articles/config-vars).

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
