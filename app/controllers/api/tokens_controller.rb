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
end