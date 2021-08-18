require "thor"

module Gnarails
  module Cli
    class Application < Thor
      include Thor::Actions

      add_runtime_options!

      WEBPACKS = %w[react vue angular elm stimulus].freeze

      method_option :ruby,
        type: :string,
        aliases: "-r",
        default: Thor::Util.ruby_command,
        desc: "Path to the Ruby binary of your choice", banner: "PATH"

      method_option :skip_namespace,
        type: :boolean,
        default: false,
        desc: "Skip namespace (affects only isolated applications)"

      method_option :skip_yarn,
        type: :boolean,
        default: false,
        desc: "Don't use Yarn for managing JavaScript dependencies"

      method_option :skip_gemfile,
        type: :boolean,
        default: false,
        desc: "Don't create a Gemfile"

      method_option :skip_git,
        type: :boolean,
        aliases: "-G",
        default: false,
        desc: "Skip .gitignore file"

      method_option :skip_keeps,
        type: :boolean,
        default: false,
        desc: "Skip source control .keep files"

      method_option :skip_action_mailer,
        type: :boolean,
        aliases: "-M",
        default: false,
        desc: "Skip Action Mailer files"

      method_option :skip_active_record,
        type: :boolean,
        aliases: "-O",
        default: false,
        desc: "Skip Active Record files"

      method_option :skip_active_storage,
        type: :boolean,
        default: false,
        desc: "Skip Active Storage files"

      method_option :skip_puma,
        type: :boolean,
        aliases: "-P",
        default: false,
        desc: "Skip Puma related files"

      method_option :skip_action_cable,
        type: :boolean,
        aliases: "-C",
        default: false,
        desc: "Skip Action Cable files"

      method_option :skip_sprockets,
        type: :boolean,
        aliases: "-S",
        default: false,
        desc: "Skip Sprockets files"

      method_option :skip_spring,
        type: :boolean,
        default: false,
        desc: "Don't install Spring application preloader"

      method_option :skip_listen,
        type: :boolean,
        default: false,
        desc: "Don't generate configuration that depends on the listen gem"

      method_option :skip_coffee,
        type: :boolean,
        default: false,
        desc: "Don't use CoffeeScript"

      method_option :skip_javascript,
        type: :boolean,
        aliases: "-J",
        default: false,
        desc: "Skip JavaScript files"

      method_option :skip_turbolinks,
        type: :boolean,
        default: false,
        desc: "Skip turbolinks gem"

      method_option :skip_test,
        type: :boolean,
        aliases: "-T",
        default: false,
        desc: "Skip test files"

      method_option :skip_system_test,
        type: :boolean,
        default: false,
        desc: "Skip system test files"

      method_option :skip_bootsnap,
        type: :boolean,
        default: false,
        desc: "Skip bootsnap gem"

      method_option :dev,
        type: :boolean,
        default: false,
        desc: "Setup the application with Gemfile pointing to your Rails checkout"

      method_option :edge,
        type: :boolean,
        default: false,
        desc: "Setup the application with Gemfile pointing to Rails repository"

      method_option :rc,
        type: :string,
        default: nil,
        desc: "Path to file containing extra configuration options for rails command"

      method_option :no_rc,
        type: :boolean,
        default: false,
        desc: "Skip loading of extra configuration options from .railsrc file"

      method_option :api,
        type: :boolean,
        desc: "Preconfigure smaller stack for API only apps"

      method_option :skip_bundle,
        type: :boolean,
        aliases: "-B",
        default: false,
        desc: "Don't run bundle install"

      method_option :webpack,
        type: :string,
        default: nil,
        desc: "Preconfigure for app-like JavaScript with Webpack (options: #{WEBPACKS.join('/')})"

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
      def new(name)
        Kernel.system command(name, options)
      end

      no_tasks do
        def command(name, options)
          "rails new #{name} #{cli_options(options)}"
        end

        def cli_options(options)
          options_string = "-m #{Gnarails.template_file} --skip-test-unit --database=postgresql"
          options.each_with_object(options_string) do |(k, v), str|
            str << cli_option(k, v)
          end
        end

        def cli_option(key, value)
          if value == false
            ""
          elsif value == true
            " --#{key}"
          else
            " --#{key}=#{value}"
          end
        end
      end
    end
  end
end
