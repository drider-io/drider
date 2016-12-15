class Users::LoginsController < ApplicationController
  def new
    if current_user
      current_user.update!(fb_chat_id: fb_chat_user_id)
      redirect_to params['redirect_uri'] + "&authorization_code=#{current_user.id}"
    else
      redirect_to omniauth_authorize_path(User, 'facebook', fb_chat_id: fb_chat_user_id, redirect_uri: params[:redirect_uri])
    end
  end

  private

  def fb_chat_user_id
    fb_data = Koala::Facebook::API.new(ENV['facebook_page_access_token']).get_object("me?fields=recipient&account_linking_token=#{params['account_linking_token']}")
    fb_data['recipient']
  end
end
