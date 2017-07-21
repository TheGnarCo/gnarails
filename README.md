This repo contains a rails template, and all necessary associated files, to provide a fully-loaded Gnar Rails app. Clone this repo locally to use.

# Usage
```sh
$ git clone https://github.com/TheGnarCo/gnarails.git
$ cd where/app/will/go
$ rails new <APP_NAME> -m path/to/gnarly.rb --skip-test-unit --database=postgresql
```

A`.railsrc` is provided. If you'd like to symlink it to your home directory, it'll run `rails new` with the options to run with postgres and not including test-unit. This `.railsrc` can be personalized to include the `--template=path/to/gnarly.rb` option depending on where you locally store this repo if you'd like to use this template every time.

Error while installing pronto? Try installing cmake
```sh
brew install cmake
```

# Post-Install
* Generate a Personal Access Token from the gnarbot github account.
  - Settings > Personal access tokens > Generate new token.
  - Use the repo name for the token description.
  - Provide the repo scope.
  - Generate token.
  - Store/copy the token temporarily.

* Store the token value in circle.
  - Find the repo settings.
  - Build Settings > Environment Variables.
  - Add Variable.
  - Name the variable `PRONTO_GITHUB_ACCESS_TOKEN` with the value from the previous Personal Access Token.

# Switching out Capybara Driver
If you'd like to not run your tests headless, for example, to troubleshoot an issue and see what's on the screen, modify the `Capybara.javascript_driver` in `spec/rails_helper.rb` to use `:chome` instead of `:headless_chrome`. After the change, this line should look as follows:

```
Capybara.javascript_driver = :chrome
```

# Updating gnar-style

Should the gnar-style gem ever update with new style configurations and you want to utilize them in your rails app, you must run the following command after upgrading the dependency with bundler:

```bash
$ bundle exec gnar-style copy_local --format=rails
```

This will pull the new files in from the gem into your local repository. The `.rubocop.yml` file is inheriting from these local files, rather than from the gem.

This is due to the use of `pronto`. The gnar-style gem does provide an [easier mechanism](https://github.com/TheGnarCo/gnar-style#inheriting-from-the-gem) to have these styles pulled directly from the gem. However, this requires that rubocop be run with `bundle exec rubocop` so the `inherit_gem` directive in rubocop can determine where the gem is. Unfortunately, that does not appear to play nicely with the [pronto-rubocop](https://github.com/prontolabs/pronto-rubocop) runner, which this template uses.
