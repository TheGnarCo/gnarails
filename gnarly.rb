# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

gem 'pg'

gem_group :development, :test do
  gem 'bullet'
  gem 'bundler-audit'
  # gem 'capybara'
  # gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  # gem 'pronto'
  # gem 'pronto-brakeman', require: false
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-scss', require: false
  gem 'pry-rails'
  gem 'rspec-its'
  gem 'rspec-rails'
  # gem 'rubocop', require: false
  # gem 'scss_lint', require: false
  # gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  # gem 'simplecov', require: false
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

# Retrieve all gems and set up git
after_bundle do
  remove_dir "test"
  git :init
end
