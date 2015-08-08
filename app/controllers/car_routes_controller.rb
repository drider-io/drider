class CarRoutesController < ApplicationController
  layout 'account'
  before_action { menu_set_active('routes') }
  before_action :user_required

  def index
    @routes = current_user.car_routes.order('driven_at DESC')
  end

  def show
    route = current_user.car_routes.find(params['id'])
    respond_to do |format|
      format.json { render :json => CarRouteSerializer.new(route) }
    end
  end
  def update

  end

  def destroy

  end
end