class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_layout#, :authorize_token_user!

  helper_method :menu_set_active, :unread_messages_count, :unread_requests_count

  def set_layout
    @layout_name ='application'
  end

  def user_required
    redirect_to new_user_session_url, notice: 'Потрібно залогуватись' unless current_user
  end

  def menu_set_active(name)
    @active_menu = name
  end

  def unread_requests_count
    return 0 unless current_user
    CarRequest.unread(current_user).count
  end
  def unread_messages_count
    return 0 unless current_user
    Message.unread(current_user).count
  end

  def route_helper
    if !current_user.role_defined?
      redirect_to role_select_account_path
    elsif current_user.driver_role? && !current_user.ever_drive?
      redirect_to route_required_account_url
    elsif unread_requests_count>0
      redirect_to car_requests_url
    elsif unread_messages_count>0
      redirect_to messages_url
    elsif current_user.driver_role?
      redirect_to passenger_search_index_url
    else
      redirect_to car_searches_url
    end
  end

  # def authorize_token_user!
  #   token = request.headers['Auth-Token']
  #   if token.present? && !user_signed_in?
  #     sleep(rand(200) / 1000.0)
  #     user = User.where(authentication_token: token).first
  #     sign_in(user) if user
  #   end
  # end

  def authenticate_admin_user!
     if current_user.try(:is_admin)
       true
     else
       flash[:alert] = 'Your account does not have administrative permissions.'
       redirect_to root_path
     end
   end
end
