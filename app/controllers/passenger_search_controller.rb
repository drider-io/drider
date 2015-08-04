class PassengerSearchController < ApplicationController
  layout 'account'
  before_action :user_required
  before_action { menu_set_active('search') }

  def index
    routes = current_user.car_routes
    @results = PassengerSearcher.new(routes: routes).search
  end
end
