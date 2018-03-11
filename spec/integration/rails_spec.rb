require "spec_helper"

RSpec.describe "Sample App Integration Testing" do
  context "outside of CI", unless: ENV["CI"] do
    before do
      `rm -R rails-test-app` if File.directory?("rails-test-app")
      puts "Creating test app from gnarails"

      Bundler.with_clean_env do
        `sh ./bin/test-setup.sh`
      end

      puts "Created test app from gnarails"
    end

    it "runs test-app suite" do
      Bundler.with_clean_env do
        Dir.chdir('rails-test-app') do
          `bundle exec rspec`
          test_app_result=$?.success?

          expect(test_app_result).to be true
        end
      end
    end
  end

  # TODO: ignore entirely
  # investigate use of a workflow to run test app test suite:
  # https://circleci.com/docs/2.0/workflows/
  # will that actually help? Won't that just have the same problem?
  # maybe dump the created app in a workspace which a separate workflow picks up?

  # context "in CI", if: ENV["CI"] do
  #   before do
  #     `docker-compose build`
  #     `docker-compose run web bundle exec rake db:create RAILS_ENV=test`
  #     `docker-compose run web bundle exec rake db:migrate RAILS_ENV=test`
  #   end
  #
  #   it "runs test-app suite" do
  #     # TODO: this should fail if the command(s) fail. Currently, it doesn't
  #     `docker-compose run web bundle exec rspec`
  #   end
  # end
end
