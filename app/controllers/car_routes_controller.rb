class CarRoutesController < ApplicationController
  layout 'account'
  before_action { menu_set_active('search') }
  before_action :user_required

  def index
    @routes = CarRoute.where(user: current_user).order('driven_at DESC')
  end

  def show
    route = CarRoute.where(user: current_user).find(params['id'])
    respond_to do |format|
      format.json { render :json => CarRouteSerializer.new(route) }
    end
  end
  def update

  end

  def destroy

  end
end