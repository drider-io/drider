require "rails_helper"

RSpec.describe CarSearchesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/car_searches").to route_to("car_searches#index")
    end

    it "routes to #new" do
      expect(:get => "/car_searches/new").to route_to("car_searches#new")
    end

    it "routes to #show" do
      expect(:get => "/car_searches/1").to route_to("car_searches#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/car_searches/1/edit").to route_to("car_searches#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/car_searches").to route_to("car_searches#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/car_searches/1").to route_to("car_searches#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/car_searches/1").to route_to("car_searches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/car_searches/1").to route_to("car_searches#destroy", :id => "1")
    end

  end
end
