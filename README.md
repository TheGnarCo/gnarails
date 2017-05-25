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

* Store the token value in circle
  - Find the repo settings
  - Build Settings > Environment Variables
  - Add Variable
  - Name the variable `PRONTO_GITHUB_ACCESS_TOKEN` with the value from the previous Personal Access Token
