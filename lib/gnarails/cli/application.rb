require "thor"

module Gnarails
  module Cli
    class Application < Thor
      include Thor::Actions

      attr_reader :args

      def initialize(args)
        @args = args
        super(args)
      end

      add_runtime_options!

      desc "new APP_PATH [options]", "generate a gnarly rails app"
      long_desc <<-LONGDESC
        `gnarails new NAME` will create a new rails application called NAME,
        pre-built with the same helpful default configuration you can expect from
        any rails project built by The Gnar Company.

        By default, we pass arguments to `rails new` that skip test unit
        generation and use postgres instead of sqlite as the default database.

        You should also be able to pass any other arguments you would expect to
        be able to when generating a new rails app.
      LONGDESC
      def new
        Kernel.system "rails new #{cli_options}"
      end

      no_tasks do
        def cli_options
          "-m #{Gnarails.template_file} --skip-test-unit --database=postgresql #{args.join(" ")}"
        end
      end
    end
  end
end
