class PassengerSearchController < ApplicationController
  layout 'account'
  before_action :user_required
  before_action { menu_set_active('search') }
  helper_method :is_passenger_ok?

  def index
    routes = current_user.car_routes
    @results = PassengerSearcher.new(routes: routes).search
  end

  def show
    
  end

  private

  def is_passenger_ok?(passenger)
    @car_requests_passengers_ids ||= CarRequest.where(driver: current_user).where.not(status: ['finished','canceled']).map(&:passenger_id)
    @car_requests_passengers_ids << current_user.id
    !passenger.in?(@car_requests_passengers_ids)
  end

end
