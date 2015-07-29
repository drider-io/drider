class CarRoutesController < ApplicationController
  before_action :user_required

  def index
    @routes = CarRoute.where(user: current_user)
  end

  def show

  end

  def update

  end

  def destroy

  end
end