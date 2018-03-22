require "spec_helper"
require "gnarails/cli/application"

module Gnarails
  module Cli
    RSpec.describe Application do
      describe ".new" do
        subject(:application) { Gnarails::Cli::Application.new }

        it "creates a new rails application" do
          allow(Kernel).to receive(:system)

          application.new("name", "--option")

          options = "--skip-test-unit --database=postgresql --option"
          expect(Kernel).to have_received(:system)
            .with("rails new name -m #{Gnarails.template_file} #{options}")
        end

        context "trying to use webpacker" do
          it "does not allow the command to complete" do
            expect { capture(:stdout) { application.new("name", "--webpack") } }
              .to raise_error SystemExit
          end
        end
      end

      def capture(stream)
        begin
          stream = stream.to_s
          eval("$#{stream} = StringIO.new")
          yield
          result = eval("$#{stream}").string
        ensure
          eval("$#{stream} = #{stream.upcase}")
        end

        result
      end
    end
  end
end
