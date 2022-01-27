require "spec_helper"

RSpec.describe "Sample App Integration Testing" do
  context "generating a sample application", unless: ENV["CI"] do
    before do
      `rm -R rails-test-app` if File.directory?("rails-test-app")

      Bundler.with_clean_env do
        `sh ./bin/test-setup.sh`
      end
    end

    it "runs test-app suite" do
      Bundler.with_clean_env do
        Dir.chdir("rails-test-app") do
          `bundle exec rspec`
          test_app_result = $?.success?

          expect(test_app_result).to be true
        end
      end
    end
  end
end
