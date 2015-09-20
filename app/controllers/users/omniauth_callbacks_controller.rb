class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    token = request.env["omniauth.auth"].try('credentials').try('token')
    email = Koala::Facebook::API.new(token).get_object("me?fields=email").try(:[], 'email') if token.present?
    unless email
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      return
    end
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"], email)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if session[:push_init]
        @user.devices.create(session[:push_init])
        session.delete(:push_init)
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_session_url
    end
  end
end
