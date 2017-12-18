require "bundler/setup"
require "gnarails"
require "rspec/expectations"
# require_relative "../gnarly"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    puts "before suite"
    # changed_dir=Dir.pwd
    # puts "you're now in directory #{changed_dir}"
    # `rails new rails-test-app -m gnarly.rb --skip-test-unit --database=postgresql`
    # exec "rails new rails-test-app -m gnarly.rb --skip-test-unit --database=postgresql"
    # exec "./bin/test-setup.sh"
    # `./bin/test-setup.sh`
    # %x(./bin/test-setup.sh)
    # system "bash", "./bin/test-setup.sh"
    # system "rails new rails-test-app -m #{Gnarails.template_file} --skip-test-unit --database=postgresql"
    # exec "rails new rails-test-app -m #{Gnarails.template_file} --skip-test-unit --database=postgresql"
  end

  config.after(:suite) do
    `rm -R rails-test-app`
  end
end
