require 'rails_helper'

RSpec.describe "CarSearches", type: :request do
  describe "GET /car_searches" do
    it "works! (now write some real specs)" do
      get car_searches_path
      expect(response).to have_http_status(200)
    end
  end
end
