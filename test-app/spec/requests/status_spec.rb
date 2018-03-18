require "rails_helper"

RSpec.describe "Status endpoint", type: :request do
  describe "/okcomputer" do
    it "reports that the application is up" do
      get "/okcomputer"

      expect(response).to be_ok
    end
  end
end
