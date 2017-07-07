class MessagesRouter < RootRouter
  def perform
    return if @message.messaging['message']['is_echo']
    auth_user
    if @message.try(:attachments).try(:first).try(:[], 'type') == 'location'
      coordinates = @message.attachments.first['payload']['coordinates']
      if coordinates.present?
        user.send(:location!, nil, coordinates)
      end
    else
      user.send(:text!, nil, @message.try(:text))
    end
  end
end
