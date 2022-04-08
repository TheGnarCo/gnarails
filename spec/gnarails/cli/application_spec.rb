require "spec_helper"

module Gnarails
  module Cli
    RSpec.describe Application do
      describe "#new" do
        it "creates a new rails application" do
          application = Gnarails::Cli::Application.new

          allow(Kernel).to receive(:system)

          application.options = { webpack: "react", skip_yarn: false, skip_git: true }
          application.new("name")

          default_options = "-m #{Gnarails.template_file} " + %w[
            --asset-pipeline=propshaft
            --skip-test-unit
            --css=sass
            --javascript=esbuild
            --database=postgresql
          ].join(" ")

          options = "#{default_options} --webpack=react --skip_git"

          expect(Kernel).to have_received(:system)
            .with("rails new name #{options}")
        end
      end
    end
  end
end
