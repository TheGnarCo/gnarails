require "thor"

module Gnarails
  module Cli
    class Application < Thor
      include Thor::Actions

      add_runtime_options!

      desc "new APP_PATH [options]", "generate a gnarly rails app"
      long_desc <<-LONGDESC
        `gnarails new NAME` will create a new rails application called NAME,
        pre-built with the same helpful default configuration you can expect from
        any rails project built by The Gnar Company.

        By default, we pass arguments to `rails new` that:
        - skip test unit (We'll install rspec later)
        - use postgres over SQLlite,
        - use Propshaft,
        - Bundle CSS with cssbundling (using scss)
        - bundle JS with esbuild

        You should also be able to pass any other arguments you would expect to
        be able to when generating a new rails app. Use `rails -h` for more
        information.
      LONGDESC
      def new(name)
        Kernel.system command(name, options)
      end

      DEFAULT_OPTIONS = [
        "--asset-pipeline=propshaft",
        "--skip-test-unit",
        "--css=scss",
        "--javascript=esbuild",
        "--database=postgresql",
      ].freeze

      no_tasks do
        def command(name, options)
          "rails new #{name} #{cli_options(options)}"
        end

        def cli_options(options)
          options_string = "-m #{Gnarails.template_file} " + DEFAULT_OPTIONS.join(' ')
          options.each_with_object(options_string) do |(k, v), str|
            str << cli_option(k, v)
          end
        end

        def cli_option(key, value)
          case value
          when false
            ""
          when true
            " --#{key}"
          else
            " --#{key}=#{value}"
          end
        end
      end
    end
  end
end
