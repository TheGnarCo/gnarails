require "gnarails/cli/application"
require "gnarails/version"

module Gnarails
  def self.template_file
    File.join(File.dirname(__FILE__), "..", "gnarly.rb")
  end
end
