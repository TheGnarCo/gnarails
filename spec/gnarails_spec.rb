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
