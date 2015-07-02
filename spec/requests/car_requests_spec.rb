require 'rails_helper'

RSpec.describe "CarRequests", type: :request do
  describe "GET /car_requests" do
    it "works! (now write some real specs)" do
      get car_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
