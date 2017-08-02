# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

gem 'pg'

gem_group :development, :test do
  gem 'axe-matchers'
  gem 'bullet'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
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

# FactoryGirl
copy_file "templates/spec/support/factory_girl.rb", "spec/support/factory_girl.rb"

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

# Database Cleaner
insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  "  config.before(:suite) do\n    DatabaseCleaner.clean_with(:truncation)\n  end\n\n  config.before(:each) do\n    DatabaseCleaner.strategy = :transaction\n  end\n\n  config.before(:each, :js => true) do\n    DatabaseCleaner.strategy = :truncation\n  end\n\n  config.before(:each) do\n    DatabaseCleaner.start\n  end\n\n  config.after(:each) do\n    DatabaseCleaner.clean\n  end\n\n"
end

gsub_file "spec/rails_helper.rb",
          "config.use_transactional_fixtures = true",
          "config.use_transactional_fixtures = false"

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
copy_file "templates/circle.yml", "circle.yml"

# Capybara
insert_into_file "spec/rails_helper.rb", after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
  "require \"capybara/rails\"\n"\
    "require \"axe/rspec\"\n"\
    "require \"selenium/webdriver\"\n"
end

append_to_file "spec/rails_helper.rb" do
  "\n\nCapybara.register_driver :chrome do |app|\n"\
    "  Capybara::Selenium::Driver.new(app, browser: :chrome)\n"\
    "end\n\n"\
    "Capybara.register_driver :headless_chrome do |app|\n"\
    "  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(\n"\
    "    chromeOptions: { args: [\n"\
    "      \"headless\",\n"\
    "      \"disable-gpu\",\n"\
    "      \"no-sandbox\",\n"\
    "      \"disable-extensions\",\n"\
    "      \"start-maximized\"\n"\
    "    ] }\n"\
    "  )\n\n"\
    "  Capybara::Selenium::Driver.new app,\n"\
    "    browser: :chrome,\n"\
    "    desired_capabilities: capabilities\n"\
    "end\n\n"\
    "Capybara.javascript_driver = :headless_chrome\n"\
    "Capybara.default_max_wait_time = 3\n"
end

# Retrieve all gems, set up git, display next steps
after_bundle do
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
