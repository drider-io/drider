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
end
