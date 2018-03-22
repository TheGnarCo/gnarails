require "thor"

module Gnarails
  module Cli
    class Application < Thor
      include Thor::Actions

      desc "new <name> <rails-options>", "generate a gnarly rails app"
      long_desc <<-LONGDESC
        `gnarails new NAME` will create a new rails application called NAME,
        pre-built with the same helpful default configuration you can expect from
        any rails project built by The Gnar Company.

        By default, we pass arguments to `rails new` that skip test unit
        generation and use postgres instead of sqlite as the default database.

        You should also be able to pass any other arguments you would expect to
        be able to when generating a new rails app.
      LONGDESC
      def new(name, rails_options = nil)
        disallow_webpack(name, rails_options) if rails_options&.include?("--webpack")

        default_options = "--skip-test-unit --database=postgresql"

        Kernel.system "rails new #{name} -m #{Gnarails.template_file} #{default_options} #{rails_options}"
      end

      no_tasks do
        def disallow_webpack(app_name, rails_options)
          puts webpack_error(app_name, rails_options)
          exit(1)
        end

        def webpack_error(app_name, rails_options)
          <<~ERROR
            ⚠️  Gnarails cannot create your new rails app. ⚠️
            ================================================
            Unfortunately, there's currently an issue installing webpacker using the gnarails CLI tool to create a new rails application.

            ⚡️  Workaround ⚡️
            ================
            You can still create a gnarly rails app using the template directly:

            rails new #{app_name} -m https://raw.githubusercontent.com/TheGnarCo/gnarails/master/gnarly.rb --skip-test-unit --database=postgresql #{rails_options}

            🛠  Help Wanted 🛠
            =================
            We'd love your help to resolve this issue. We welcome any assistance or insight you may have on this here: https://github.com/TheGnarCo/gnarails/issues/90.
          ERROR
        end
      end
    end
  end
end
