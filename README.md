# Gnarails

This repo contains a rails template, and all necessary associated files, to provide a fully-loaded Gnar Rails app.

## Usage

This template relies on pronto, which needs [cmake](https://cmake.org/) installed.

### Using the CLI

```sh
$ gem install gnarails
$ gnarails new <APP_NAME>
```

### Using the template

If you want to reference the template directly and don't want to use the
gnarails CLI command, you may clone the project (or reference the template from
its HTTP location on github):

```sh
$ git clone https://github.com/TheGnarCo/gnarails.git
$ cd where/app/will/go
$ rails new <APP_NAME> -m path/to/gnarly.rb --skip-test-unit --database=postgresql
```

A`.railsrc` is provided. If you'd like to symlink it to your home directory, it'll run `rails new` with the options to run with postgres and not including test-unit. This `.railsrc` can be personalized to include the `--template=path/to/gnarly.rb` option depending on where you locally store this repo if you'd like to use this template every time.

## Usage with React

### Using the template

```sh
$ git clone https://github.com/TheGnarCo/gnarails.git
$ cd where/app/will/go
$ rails new <APP_NAME> -m path/to/gnarly.rb --skip-test-unit --database=postgresql --webpack=react
```

## Post-Install

```sh
$ cd <APP_NAME>
$ bin/bundle
$ bin/rails db:create
$ bin/rails db:migrate
```

_For React Apps_

```sh
$ bin/yarn
$ bin/yarn test
```

* Generate a Personal Access Token from the gnarbot github account.
  - Settings > Developer settings > Personal access tokens > Generate new token.
  - Use the repo name for the token description.
  - Provide the repo scope.
  - Generate token.
  - Store/copy the token temporarily.

* Store the token value in circle.
  - Find the repo settings.
  - Build Settings > Environment Variables.
  - Add Variable.
  - Name the variable `PRONTO_GITHUB_ACCESS_TOKEN` with the value from the previous Personal Access Token.

## Usage with Docker

A `Dockerfile` and `docker-compose.yml` file are created by default. When run with `--webpack=react`,
there are two `Dockerfile`s: one for the Rails server and one for the assets server.

To use Docker, run:

```sh
docker-compose build
```

then set up the database:

```sh
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

finally, start the server and visit `localhost:3000`:

```sh
docker-compose up
```

## Switching out Capybara Driver
If you'd like to not run your tests headless, for example, to troubleshoot an issue and see what's on the screen, modify the `driven_by` driver in `spec/support/system_test_configuration.rb` to use `:selenium_chrome` instead of `:selenium_chrome_headless`. After the change, this block should look as follows:

```ruby
config.before(:each, type: :system, js: true) do
  driven_by :selenium_chrome
end
```

## Updating gnar-style

After updating the gnar-style gem, you must take care to ensure that your local rubocop file does not stray from the update made to the gem in an unintended manner. Any changes in the local rubocop file will take precedence over what is in the gnar-style gem. See the gnar-style [docs](https://github.com/TheGnarCo/gnar-style#overriding-styles) for more details.

## Running the Application

```sh
$ bin/rails s
```

_For React Apps_

In a separate terminal window/tab

```sh
$ bin/yarn start
```

Visit `localhost:3000` in your browser

## About The Gnar Company

![The Gnar Company](https://avatars0.githubusercontent.com/u/17011419?s=100&v=4)

The Gnar Company is a Boston-based development company that builds robust
web and mobile apps designed for the long haul.

For more information see [our website](https://www.thegnar.co/).
