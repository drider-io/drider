class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :menu_set_active

  def user_required
    redirect_to new_user_session_url, notice: 'Потрібно залогуватись' unless current_user
  end

  def menu_set_active(name)
    @active_menu = name
  end
end
