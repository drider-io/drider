class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    token = request.env["omniauth.auth"].try('credentials').try('token')

    @user = User.from_omniauth(request.env["omniauth.auth"])


    email = Koala::Facebook::API.new(token).get_object("me?fields=email").try(:[], 'email') if token.present?
    unless email
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      return
    end
    @user.email = email

    fb_chat_id = request.env["omniauth.params"].try(:[], 'fb_chat_id')
    @user.fb_chat_id = fb_chat_id if fb_chat_id.present?

    @user.save!
    # You need to implement the method below in your model (e.g. app/models/user.rb)

    redirect_uri = request.env["omniauth.params"].try(:[], 'redirect_uri')

    if @user.persisted?
      sign_in(@user, :event => :authentication)
      # sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if session[:push_init]
        @user.devices.create(session[:push_init])
        session.delete(:push_init)
      end
      link_searches(@user, session[:unsaved_searches])
      session.delete :unsaved_searches
      if redirect_uri.present?
        redirect_to redirect_uri + "&authorization_code=#{@user.id}"
      else
        redirect_to after_sign_in_path_for(@user)
      end
    else
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
      if redirect_uri.present?
        redirect_to redirect_uri #omniauth_authorize_path(User, 'facebook', account_linking_token: request.env["omniauth.params"]['account_linking_token'], redirect_uri: redirect_uri)
      else
        redirect_to new_user_session_url
      end
    end
  end

  private

  def link_searches(user, search_ids)
    if search_ids.is_a?(Array) && search_ids.present?
      CarSearch.where(user_id: nil).where(id: search_ids).update_all(user_id: user.id)
    end
  end
end
