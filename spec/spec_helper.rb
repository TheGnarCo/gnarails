require "bundler/setup"
require "gnarails"
require "rspec/expectations"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # TODO: only run this before the particular integration example
  # pull test into separate file
  # do different setup for CI
  config.before(:suite) do
    `rm -R rails-test-app` if File.directory?("rails-test-app")
    puts "Creating test app from gnarails"

    Bundler.with_clean_env do
      `sh ./bin/test-setup.sh`
    end

    puts "Created test app from gnarails"
  end
end
