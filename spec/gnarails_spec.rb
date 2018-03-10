require "spec_helper"

RSpec.describe Gnarails do
  it "has a version number" do
    expect(Gnarails::VERSION).not_to be nil
  end

  it "adds bundler-audit to the gemfile" do
    gemfile = "rails-test-app/Gemfile"
    contains_audit = File.readlines(gemfile).grep(/bundler-audit/).any?

    expect(contains_audit).to be true
  end

  it "runs test-app suite", unless: ENV["CI"] do
    Bundler.with_clean_env do
      Dir.chdir('rails-test-app') do
        `bundle exec rspec`
        test_app_result=$?.success?

        expect(test_app_result).to be true
      end
    end
  end

  it "runs test-app suite in CI", if: ENV["CI"] do
    `docker-compose build`
    `docker-compose run web bundle exec rake db:create RAILS_ENV=test`
    `docker-compose run web bundle exec rake db:migrate RAILS_ENV=test`
    `docker-compose run web bundle exec rspec`
  end
end
