class Api::TokenController < ApplicationController

  def gcm
    permitted_params = {push_type: 'GCM', token: params[:token], name: params[:name]}
    if current_user
      user.devices.create(permitted_params)
    else
      session[:gcm] = permitted_params
    end
    render nothing: true
  end
end