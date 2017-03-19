class PostbacksRouter
  def initialize(message)
    @message = message
  end

  def perform
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      url = URI.parse @message.payload
      options = Rack::Utils.parse_nested_query url.query
      user.send("#{url.path}!", nil, options)
    else
      FbMessage.new(@message.sender['id']).account_link.deliver
    end
  end

  def account_linking
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      FbMessage.new(@message.sender['id']).text_message("Приємно познайомитись #{user.name}").deliver
      Action::Passenger.new(@message.sender['id']).how_can_help_you
    else
      FbMessage.new(@message.sender['id']).account_link.deliver
    end
  end
end
