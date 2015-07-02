require "rails_helper"

RSpec.describe CarRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/car_requests").to route_to("car_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/car_requests/new").to route_to("car_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/car_requests/1").to route_to("car_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/car_requests/1/edit").to route_to("car_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/car_requests").to route_to("car_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/car_requests/1").to route_to("car_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/car_requests/1").to route_to("car_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/car_requests/1").to route_to("car_requests#destroy", :id => "1")
    end

  end
end
