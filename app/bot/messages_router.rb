class MessagesRouter

  def initialize(message)
    @message = message
  end

  def perform
    return if @message.messaging['message']['is_echo']
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      if @message.try(:attachments).try(:first).try(:[], 'type') == 'location'
        coordinates = @message.attachments.first['payload']['coordinates']
        if coordinates.present?
          user.send(:location!, nil, coordinates)
        end
      else
        user.send(:text!, nil, @message.try(:text))
      end
    else
      FbMessage.new(@message.sender['id']).account_link.deliver
    end
  end
end
