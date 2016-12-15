class PostbacksRouter
  def initialize(message)
    @message = message
  end

  def perform
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      user.send("#{@message.payload}!", nil, @message)
    else
      FbMessage.new(@message.sender['id']).account_link.deliver
    end
  end
end
