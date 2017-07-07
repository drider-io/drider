class RootRouter
  attr_reader :user

  def initialize(message)
    @message = message
  end

  def auth_user
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      @user = user
    else
      fb_data = Koala::Facebook::API.new(ENV['facebook_page_access_token']).get_object("#{@message.sender['id']}?fields=first_name,last_name,profile_pic")
      @user = User.create(
          fb_chat_id: @message.sender['id'],
          name: "#{fb_data['first_name']} #{fb_data['last_name']}",
          image_url: fb_data['profile_pic']
      )
      FbMessage.new(@message.sender['id']).text_message("Приємно познайомитись #{user.name}").deliver
    end
  end
end
