# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) +
    [File.expand_path(File.dirname(__FILE__))]
end

gem 'pg'

gem_group :development, :test do
  # gem 'bullet'
  gem 'bundler-audit'
  # gem 'capybara'
  # gem 'database_cleaner'
  # gem 'dotenv-rails'
  # gem 'factory_girl_rails'
  # gem 'pronto'
  # gem 'pronto-brakeman', require: false
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-scss', require: false
  # gem 'pry-rails'
  # gem 'rspec-its'
  # gem 'rspec-rails'
  # gem 'rubocop', require: false
  # gem 'scss_lint', require: false
  # gem 'selenium-webdriver'
  # gem 'shoulda-matchers'
  # gem 'simplecov', require: false
end

# Remove sqlite gem, if present
gsub_file "Gemfile", /.*sqlite.*\n/, ""

# Use scss
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"

# Set ruby version
copy_file "templates/.ruby-version", ".ruby-version"

# Use gitignore template
remove_file ".gitignore"
copy_file "templates/.gitignore", ".gitignore"

# Retrieve all gems and set up git
after_bundle do
  remove_dir "test"
  git :init
end
