# Planter
Planter helps streamline QA on your Rails apps by making it easy to create issue specific seed files for your pull requests.

## Requirements
- A Rails app with the Planter gem installed
- GitHub issues for issue tracking
- An app deployed to Heroku and using review apps

## Usage
#### Issue specific seed files
Issue specific seed files can be generated using the issue number. For example,
the following command will generate an issue specific seed file for GitHub issue #42:

    $ rails generate planter:plant 42

Once generated, the file can be found and edited at `db/plant/issue_42.rb`.

When a pull request that closes issue #42 is deployed as a Heroku review app,
the `seed` method in that file will be executed.

The `deseed` method will be executed when the review app is eventually destroyed.
This method is useful if there are changes that were made by the `seed` method
outside of the review app's environment that need reverting.

#### Default seed file
In `db/plant`, you will also find a file named `default.rb`. Define any actions
that you want performed for every review app in here.

## Installation
Include `planter` in your Gemfile:

```ruby
gem "planter", git: "https://github.com/ableco/planter.git", tag: "v0.1.1"
```

And then execute:

    $ bundle install
    $ rails generate planter:install

The Planter install script will create a `db/plant` folder with the default seed
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
the `buildpack-ruby-rake-deploy-tasks` custom buildpack.

Here's an example `app.json` file:

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
