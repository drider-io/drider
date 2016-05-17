class CarSessionsController < ApplicationController
  layout 'account'
  before_action :user_required

  def show
    @car_session = current_user.car_sessions.find(params[:id])
  end
end
