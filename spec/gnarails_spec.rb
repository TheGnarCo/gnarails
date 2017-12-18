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
end
