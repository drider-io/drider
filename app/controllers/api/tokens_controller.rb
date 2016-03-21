class Api::TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def gcm
    permitted_params = {push_type: 'GCM', token: params[:token], name: params[:name]}
    if current_user
      current_user.devices.where(permitted_params).first_or_create
    else
      session[:push_init] = permitted_params
    end
    render nothing: true
  end

  def apns
    permitted_params = {push_type: 'APN', token: params[:token], name: params[:name]}
    if current_user
      current_user.devices.where(permitted_params).first_or_create
    else
      session[:push_init] = permitted_params
    end
    render nothing: true
  end

  def facebook
    fb_data = Koala::Facebook::API.new(params['token']).get_object("me?fields=id,email,name,picture")
    email = fb_data.try(:[], 'email')
    if fb_data['id'] && email
      @user = User.from_auth(
          email:email,
          provider: 'facebook',
          uid: fb_data['id'],
          name: fb_data['name'],
          image_url: fb_data['picture']['data']['url']
      )
      if request.xhr?
        @user.save unless @user.authentication_token
        sign_in(@user)
        render json: {authentication_token: @user.authentication_token}
      else
        sign_in_and_redirect @user, :event => :authentication
      end
      if session[:push_init]
        @user.devices.create(session[:push_init])
        session.delete(:push_init)
      end
    else
      render nothing: true, status: :unprocessable_entity
    end

  end

end
