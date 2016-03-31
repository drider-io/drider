class AccountsController < ApplicationController
  layout 'account'
  before_action :user_required


  def show
    route_helper
  end


  def update

  end

  def route_required

  end

  def device_warning
    @client = params[:client]
    @location = params[:location]
    @notifications = params[:notifications]
  end

  def driver_role
    current_user.update!(driver_role: params[:value])
    redirect_to :root
  end

  private
  def account_params
       params.permit(:driver_role)
  end

end
