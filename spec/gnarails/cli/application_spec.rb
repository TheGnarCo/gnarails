require "spec_helper"

module Gnarails
  module Cli
    RSpec.describe Application do
      describe "#new" do
        it "creates a new rails application" do
          application = Gnarails::Cli::Application.new

          allow(Kernel).to receive(:system)

          application.new("name")

          expect(Kernel).to have_received(:system)
            .with("rails new name --rc=.railsrc")
        end
      end
    end
  end
end
