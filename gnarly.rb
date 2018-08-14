# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

RUBY_VERSION = "2.5.0".freeze

JS_DEPENDENCIES = [
  "babel-preset-es2015".freeze,
  "babel-preset-stage-0".freeze,
  "classnames".freeze,
  "es6-object-assign".freeze,
  "es6-promise".freeze,
  "history".freeze,
  "lodash".freeze,
  "react-entity-getter".freeze,
  "react-redux".freeze,
  "react-router".freeze,
  "react-router-dom".freeze,
  "react-router-redux@next".freeze,
  "redux".freeze,
  "redux-form".freeze,
  "redux-thunk".freeze,
  "schlepp".freeze,
].freeze

JS_DEV_DEPENDENCIES = [
  "babel-eslint".freeze,
  "enzyme".freeze,
  "enzyme-adapter-react-16".freeze,
  "eslint".freeze,
  "eslint-config-airbnb".freeze,
  "eslint-plugin-import".freeze,
  "eslint-plugin-jsx-a11y@^5.1.1".freeze,
  "eslint-plugin-react".freeze,
  "expect".freeze,
  "jsdom".freeze,
  "mocha".freeze,
  "nock".freeze,
  "react-dom".freeze,
  "react-test-renderer".freeze,
  "redux-mock-store".freeze,
].freeze

def create_gnarly_rails_app
  # This is a really unfortunate, but necessary line of code that resets the
  # cached Gemfile location so the generated application's Gemfile is used
  # instead of the generators Gemfile.
  ENV["BUNDLE_GEMFILE"] = nil

  add_gems

  run "bundle install"

  after_bundle do
    setup_database
    add_ruby_version
    setup_scss
    setup_gitignore
    setup_testing
    setup_analysis
    setup_environments
    setup_readme
    setup_react if react?
    remove_dir "test"
    git :init
    format_ruby
    completion_notification
  end
end

def add_gems
  gem_group :development, :test do
    gem 'axe-matchers'
    gem 'bullet'
    gem 'bundler-audit'
    gem 'capybara'
    gem 'dotenv-rails'
    gem 'factory_bot_rails'
    gem 'gnar-style', require: false
    gem 'lol_dba'
    gem 'okcomputer'
    gem 'pronto'
    gem 'pronto-brakeman', require: false
    gem 'pronto-rubocop', require: false
    gem 'pronto-scss', require: false
    gem 'pry-rails'
    gem 'rspec-its'
    gem 'rspec-rails'
    gem 'scss_lint', require: false
    gem 'selenium-webdriver'
    gem 'shoulda-matchers'
    gem 'simplecov', require: false
  end
end

def setup_database
  remove_file "config/database.yml"
  copy_file "templates/database.yml", "config/database.yml"
  gsub_file "config/database.yml", "__application_name__", app_name

  gsub_file "Gemfile", /.*sqlite.*\n/, ""
end

def add_ruby_version
  insert_into_file "Gemfile", after: "source 'https://rubygems.org'" do
    "\nruby \"#{RUBY_VERSION}\""
  end

  copy_file "templates/.ruby-version", ".ruby-version"
  gsub_file ".ruby-version", "__ruby_version__", RUBY_VERSION
end

def setup_scss
  run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"
end

def setup_gitignore
  remove_file ".gitignore"
  copy_file "templates/.gitignore", ".gitignore"
end

def setup_testing
  setup_rspec
  setup_factory_bot
  setup_system_tests
  setup_shoulda
  setup_bullet
  limit_test_logging
end

def setup_rspec
  generate "rspec:install"
  remove_file ".rspec"
  copy_file "templates/.rspec", ".rspec"
  gsub_file "spec/rails_helper.rb",
    /# Dir\[Rails\.root\.join.*/,
    "Dir[Rails.root.join(\"spec/support/**/*.rb\")].each { |f| require f }"
end

def setup_factory_bot
  copy_file "templates/spec/support/factory_bot.rb", "spec/support/factory_bot.rb"
end

def setup_system_tests
  copy_file "templates/spec/support/system_test_configuration.rb",
    "spec/support/system_test_configuration.rb"

  insert_into_file "spec/rails_helper.rb", after: "Rails is not loaded until this point!\n" do
    system_tests_rails_helper_text
  end

  append_to_file "spec/rails_helper.rb" do
    "\nCapybara.default_max_wait_time = 3\n"
  end
end

def system_tests_rails_helper_text
  <<~SYSTEM_TESTS
    require "capybara/rails"
    require "axe/rspec"
    require "selenium/webdriver"
  SYSTEM_TESTS
end

def setup_shoulda
  append_to_file "spec/rails_helper.rb" do
    shoulda_rails_helper_text
  end
end

def shoulda_rails_helper_text
  <<~SHOULDA

    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  SHOULDA
end

def setup_bullet
  insert_into_file "config/environments/test.rb", after: "Rails.application.configure do" do
    bullet_test_env_text
  end

  insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|" do
    bullet_rails_helper_text
  end
end

def bullet_test_env_text
  <<-BULLET_TEST

  # Bullet gem initialization
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.raise = true
  end
  BULLET_TEST
end

def bullet_rails_helper_text
  <<-BULLET_RAILS

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
  BULLET_RAILS
end

def limit_test_logging
  insert_into_file "config/environments/test.rb", after: "Rails.application.configure do" do
    <<-TEST_LOGGING

  unless ENV[\"RAILS_ENABLE_TEST_LOG\"]
    config.logger = Logger.new(nil)
    config.log_level = :fatal
  end
    TEST_LOGGING
  end
end

def setup_analysis
  setup_linting
  setup_pronto
  setup_brakeman
  setup_simplecov
end

def setup_linting
  copy_file "templates/.rubocop.yml", ".rubocop.yml"
  copy_file "templates/.scss-lint.yml", ".scss-lint.yml"
end

def setup_pronto
  copy_file "templates/.pronto.yml", ".pronto.yml"
  copy_file "templates/script/ci_pronto", "script/ci_pronto"
  run "chmod +x script/ci_pronto"
end

def setup_brakeman
  copy_file "templates/script/brakeman", "script/brakeman"
  run "chmod +x script/brakeman"
end

def setup_simplecov
  prepend_to_file "spec/spec_helper.rb" do
    <<~SIMPLECOV
      require "simplecov"

      # Save to CircleCI's artifacts directory if we're on CircleCI
      if ENV["CIRCLE_ARTIFACTS"]
        dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
        SimpleCov.coverage_dir(dir)
      end

      SimpleCov.start "rails" if (ENV["CI"] || ENV["COVERAGE"])

    SIMPLECOV
  end
end

def setup_environments
  setup_dotenv
  setup_ci
  setup_docker
end

def setup_dotenv
  copy_file "templates/.env.development", ".env.development"
  copy_file "templates/.env.test", ".env.test"
  gsub_file ".env.development", "__application_name__", app_name
  gsub_file ".env.test", "__application_name__", app_name
end

def setup_ci
  copy_file "templates/.circleci/config.yml", ".circleci/config.yml"
  gsub_file ".circleci/config.yml", "__ruby_version__", RUBY_VERSION
  gsub_file ".circleci/config.yml", "__application_name__", app_name
end

def setup_docker
  copy_file "templates/Dockerfile", "Dockerfile"
  gsub_file "Dockerfile", "__ruby_version__", RUBY_VERSION

  if react?
    setup_docker_react
  else
    setup_docker_standard
  end
end

def setup_docker_standard
  copy_file "templates/.env.docker/.env.docker-standard", ".env.docker"
  copy_file "templates/docker-compose.yml/docker-compose-standard.yml", "docker-compose.yml"
end

def setup_docker_react
  copy_file "templates/Dockerfile-assets", "Dockerfile-assets"
  gsub_file "Dockerfile-assets", "__ruby_version__", RUBY_VERSION
  copy_file "templates/.env.docker/.env.docker-webpack", ".env.docker"
  copy_file "templates/.env.docker-assets", ".env.docker-assets"
  copy_file "templates/docker-compose.yml/docker-compose-webpack.yml", "docker-compose.yml"
end

def setup_readme
  remove_file "README.md"
  copy_file "templates/README.md", "README.md"
  gsub_file "README.md", "__application_name__", app_name
end

def react?
  options[:webpack] == "react"
end

def ascii_art
  puts "  _____     __        _     ____     ____     "
  puts " / / \\ \\   |  \\      | |   /    \\   |    \\    "
  puts "| |  | |   |   \\     | |  |  /\\  |  | |\\  \\   "
  puts "| |   -    |    \\    | |  | |  | |  | | |  |  "
  puts "| |        |  |\\ \\   | |  | |__| |  | |/  /   "
  puts "| |  / --  |  | \\ \\  | |  | |  | |  |    /    "
  puts "| |    \\ \\ |  |  \\ \\ | |  | |  | |  | |\\ \\    "
  puts " \\ \\   | | |  |   \\ \\| |  | |  | |  | | \\ \\   "
  puts "  \\  --/ / |  |    \\   |  | |  | |  | |  \\ \\  "
  puts "   -----/  |__|     \\__|  |_|  |_|  |_|   \\_\\ "
end

def post_install_instructions
  puts "\n\nNEXT STEPS"
  puts "=========="
  puts "* Install Google Chrome for acceptance tests"
  puts "* Install ChromeDriver for default headless acceptance tests: brew install chromedriver"
  puts "* Follow the post-install instructions to set up circle to allow gnarbot to comment on PRs."
  puts "  * https://github.com/TheGnarCo/gnarails#post-install"
end

def setup_react
  install_js_deps
  add_js_files
  modify_js_files
  modify_npm_scripts
end

def install_js_deps
  puts "Installing Gnar react packages"
  run "yarn add #{JS_DEPENDENCIES.join(' ')}"
  run "yarn add --dev #{JS_DEV_DEPENDENCIES.join(' ')}"
end

def add_js_files
  directory "templates/react/js", "app/javascript"
  directory "templates/react/views", "app/views"
  copy_file "templates/react/layout.html.erb", "app/views/layouts/application.html.erb", force: true
  copy_file "templates/react/rails_routes.rb", "config/routes.rb", force: true
  copy_file "templates/react/controllers/home_controller.rb", "app/controllers/home_controller.rb"
  copy_file "templates/react/.babelrc", ".babelrc", force: true
  copy_file "templates/react/.eslintrc.js", ".eslintrc.js", force: true
end

def modify_js_files
  gsub_file "app/views/layouts/application.html.erb",
    "placeholder_application_title",
    app_name.tr("-", "_").titleize
  gsub_file "app/javascript/app_constants/index.js",
    "  APP_NAME: 'CHANGE_ME',",
    "  APP_NAME: '#{app_name}',"
  remove_file "app/javascript/packs/application.js"
end

def modify_npm_scripts
  insert_into_file "package.json", before: "  \"dependencies\": {\n" do
    <<-NPM_SCRIPTS
  "scripts": {
    "start": "./bin/webpack-dev-server",
    "mocha": "NODE_PATH=./app/javascript mocha --compilers js:babel-register --require babel-polyfill --require app/javascript/test/.setup.js --recursive './app/javascript/**/*.tests.js*'",
    "lint": "eslint app/javascript",
    "test": "npm run lint && npm run mocha"
  },
    NPM_SCRIPTS
  end
end

def format_ruby
  run "bundle exec rubocop --auto-correct"
end

def completion_notification
  puts ""
  ascii_art
  post_install_instructions
end

create_gnarly_rails_app
