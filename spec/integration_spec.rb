require "spec_helper"
require "English"

RSpec.describe "Sample App Integration Testing" do
  context "generating a sample application", unless: ENV["CI"] do
    before do
      `rm -R rails-test-app` if File.directory?("rails-test-app")

      Bundler.with_unbundled_env do
        `sh ./bin/test-setup.sh`
      end
    end

    it "runs test-app suite" do
      Bundler.with_unbundled_env do
        Dir.chdir("rails-test-app") do
          `bin/rspec`
          test_app_result = $CHILD_STATUS.success?

          expect(test_app_result).to be true
        end
      end
    end
  end
end
