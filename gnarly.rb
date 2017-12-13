# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

JS_DEPENDENCIES = [
  "babel-preset-es2015",
  "babel-preset-stage-0",
  "classnames",
  "es6-object-assign",
  "es6-promise",
  "history",
  "lodash",
  "react-entity-getter",
  "react-redux",
  "react-router",
  "react-router-dom",
  "react-router-redux@next",
  "redux",
  "redux-form",
  "redux-thunk",
  "schlepp"
]

JS_DEV_DEPENDENCIES = [
  "babel-eslint",
  "enzyme",
  "eslint",
  "eslint-config-airbnb",
  "eslint-plugin-import",
  "eslint-plugin-jsx-a11y@^5.1.1",
  "eslint-plugin-react",
  "expect",
  "jsdom",
  "mocha",
  "nock",
  "react-dom",
  "react-test-renderer",
  "redux-mock-store"
]

def add_js_files
  directory "templates/react/js", "app/javascript"
  directory "templates/react/views", "app/views"
  copy_file "templates/react/layout.html.erb", "app/views/layouts/application.html.erb", force: true
  copy_file "templates/react/rails_routes.rb", "config/routes.rb", force: true
  copy_file "templates/react/controllers/home_controller.rb", "app/controllers/home_controller.rb"
  copy_file "templates/react/.babelrc", ".babelrc", force: true
  copy_file "templates/react/.eslintrc.js", ".eslintrc.js", force: true
  gsub_file "app/views/layouts/application.html.erb",
    "placeholder_application_title",
    app_name.gsub("-", "_").titleize
  gsub_file "app/javascript/constants/index.js", "  APP_NAME: 'CHANGE_ME',", "  APP_NAME: '#{app_name}',"
  remove_file "app/javascript/packs/application.js"
end

def install_js_deps
  puts "Installing Gnar react packages"
  run "yarn add #{JS_DEPENDENCIES.join(' ')}"
  run "yarn add --dev #{JS_DEV_DEPENDENCIES.join(' ')}"
end

def modify_npm_scripts
  insert_into_file "package.json", before: "  \"dependencies\": {\n" do
    "  \"scripts\": {\n"\
      "    \"start\": \"./bin/webpack-dev-server\",\n"\
      "    \"mocha\": \"NODE_PATH=./app/javascript mocha --compilers js:babel-register --require babel-polyfill --require app/javascript/test/.setup.js --recursive './app/javascript/**/*.tests.js*'\",\n"\
      "    \"lint\": \"eslint app/javascript\",\n"\
      "    \"test\": \"npm run lint && npm run mocha\"\n"\
      "  },\n"
  end
end

gem 'pg'

gem_group :development, :test do
  gem 'axe-matchers'
  gem 'bullet'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'gnar-style', require: false
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

# Set up database configuration
remove_file "config/database.yml"
copy_file "templates/database.yml", "config/database.yml"
gsub_file "config/database.yml", "__application_name__", "#{app_name}"

# Configure dotenv files
copy_file "templates/.env.development", ".env.development"
copy_file "templates/.env.test", ".env.test"
gsub_file ".env.development", "__application_name__", "#{app_name}"
gsub_file ".env.test", "__application_name__", "#{app_name}"

# Remove sqlite gem, if present
gsub_file "Gemfile", /.*sqlite.*\n/, ""

# Add ruby version to Gemfile
insert_into_file "Gemfile", after: "source 'https://rubygems.org'" do
  "\nruby \"2.4.2\""
end

# Use scss
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"

# Set ruby version
copy_file "templates/.ruby-version", ".ruby-version"

# Use gitignore template
remove_file ".gitignore"
copy_file "templates/.gitignore", ".gitignore"

# RSpec
run "bundle install"
run "rails generate rspec:install"
remove_file ".rspec"
copy_file "templates/.rspec", ".rspec"
gsub_file "spec/rails_helper.rb",
  "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }",
  "Dir[Rails.root.join(\"spec/support/**/*.rb\")].each { |f| require f }"

# FactoryBot
copy_file "templates/spec/support/factory_bot.rb", "spec/support/factory_bot.rb"

# System Tests
copy_file "templates/spec/support/system_test_configuration.rb", "spec/support/system_test_configuration.rb"

# Shoulda Matchers
append_to_file "spec/rails_helper.rb" do
  "\nShoulda::Matchers.configure do |config|\n  config.integrate do |with|\n    with.test_framework :rspec\n    with.library :rails\n  end\nend"
end

# Bullet
insert_into_file "config/environments/test.rb", after: "Rails.application.configure do" do
  "\n  # Bullet gem initialization\n  config.after_initialize do\n    Bullet.enable = true\n    Bullet.bullet_logger = true\n    Bullet.raise = true\n  end\n"
end

insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|" do
  "\n  if Bullet.enable?\n    config.before(:each) do\n      Bullet.start_request\n    end\n\n    config.after(:each) do\n      Bullet.perform_out_of_channel_notifications if Bullet.notification?\n      Bullet.end_request\n    end\n  end\n"
end

# Rubocop
copy_file "templates/.rubocop.yml", ".rubocop.yml"

# SCSS Lint
copy_file "templates/.scss-lint.yml", ".scss-lint.yml"

# Pronto
copy_file "templates/.pronto.yml", ".pronto.yml"
copy_file "templates/script/ci_pronto", "script/ci_pronto"
run "chmod +x script/ci_pronto"

# Brakeman CI script
copy_file "templates/script/brakeman", "script/brakeman"
run "chmod +x script/brakeman"

# Simplecov
prepend_to_file "spec/spec_helper.rb" do
  "require \"simplecov\"\n\n# save to CircleCI's artifacts directory if we're on CircleCI\n"\
    "if ENV[\"CIRCLE_ARTIFACTS\"]\n"\
    "  dir = File.join(ENV[\"CIRCLE_ARTIFACTS\"], \"coverage\")\n"\
    "  SimpleCov.coverage_dir(dir)\n"\
    "end\n\n"\
    "SimpleCov.start \"rails\" if (ENV[\"CI\"] || ENV[\"COVERAGE\"])\n\n"
end

# Circle CI
copy_file "templates/.circleci/config.yml", ".circleci/config.yml"
gsub_file ".circleci/config.yml", "__application_name__", "#{app_name}"

# Capybara
insert_into_file "spec/rails_helper.rb", after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
  "require \"capybara/rails\"\n"\
    "require \"axe/rspec\"\n"\
    "require \"selenium/webdriver\"\n"
end

append_to_file "spec/rails_helper.rb" do
  "\n\nCapybara.default_max_wait_time = 3\n"
end

react = options[:webpack] == "react"

# Docker
copy_file "templates/Dockerfile", "Dockerfile"

if react
  copy_file "templates/Dockerfile-assets", "Dockerfile-assets"
  copy_file "templates/.env.docker/.env.docker-webpack", ".env.docker"
  copy_file "templates/.env.docker-assets", ".env.docker-assets"
  copy_file "templates/docker-compose.yml/docker-compose-webpack.yml", "docker-compose.yml"
else
  copy_file "templates/.env.docker/.env.docker-standard", ".env.docker"
  copy_file "templates/docker-compose.yml/docker-compose-standard.yml", "docker-compose.yml"
end

# Retrieve all gems, set up git, display next steps
after_bundle do
  if react
    install_js_deps
    add_js_files
    modify_npm_scripts
  end

  remove_dir "test"
  git :init
  puts ""
  puts "  _____     __        _     ____     ____     "
  puts " / / \\ \\   |  \\      | |   /    \\   |    \\    "
  puts "| |  | |   |   \\     | |  |  /\\  |  | |\\  \\   "
  puts "| |   -    |    \\    | |  | |  | |  | | |  |  "
  puts "| |        |  |\\ \\   | |  |  __| |  | |/  /   "
  puts "| |  / --  |  | \\ \\  | |  | |  | |  |    /    "
  puts "| |    \\ \\ |  |  \\ \\ | |  | |  | |  | |\\ \\    "
  puts " \\ \\   | | |  |   \\ \\| |  | |  | |  | | \\ \\   "
  puts "  \\  --/ / |  |    \\   |  | |  | |  | |  \\ \\  "
  puts "   -----/  |__|     \\__|  |_|  |_|  |_|   \\_\\ "

  puts "\n\nNEXT STEPS"
  puts "=========="
  puts "* Install Google Chrome for acceptance tests"
  puts "* Install ChromeDriver for default headless acceptance tests: brew install chromedriver"
  puts "* Follow the post-install instructions to set up circle to allow gnarbot to comment on PRs. https://github.com/TheGnarCo/gnarails#post-install"
end
