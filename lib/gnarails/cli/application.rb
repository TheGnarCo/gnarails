require "thor"
require "net/http"

module Gnarails
  module Cli
    class Application < Thor
      include Thor::Actions
      RAILS_RC_FLAG = '--rc=.railsrc'

      add_runtime_options!

      desc "new APP_PATH [options]", "generate a gnarly rails app"
      long_desc <<-LONGDESC
        `gnarails new NAME` will create a new rails application called NAME,
        pre-built with the same helpful default configuration you can expect from
        any rails project built by The Gnar Company.

        Learn more about our Rails Configuration here: https://github.com/TheGnarCo/.gnarrc
      LONGDESC

      def new(name)
        create_file ".railsrc", Net::HTTP.get(URI("https://raw.githubusercontent.com/TheGnarCo/.gnarrc/main/rails/7/.railsrc"))
        Kernel.system command(name, options)
        remove_file ".railsrc"
      end

      no_tasks do
        def command(name, options)
          "rails new #{name} #{RAILS_RC_FLAG}"
        end
      end
    end
  end
end
