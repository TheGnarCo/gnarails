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
    unless File.directory?("rails-test-app")
      raise "Setup test app by running `./bin/test-setup.sh` before running suite"
    end
  end

  config.after(:suite) do
    `rm -R rails-test-app`
  end
end
