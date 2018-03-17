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

        By default, the rails generator is changed to skip test unit and to use
        Postgres as the default database. You should also be able to pass any
        arguments you would expect to be able to when generating a new rails app.
      LONGDESC
      def new(name, rails_options = nil)
        default_options = "--skip-test-unit --database=postgresql"

        system "rails new #{name} -m #{Gnarails.template_file} #{default_options} #{rails_options}"
      end
    end
  end
end
