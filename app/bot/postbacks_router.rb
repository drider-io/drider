class PostbacksRouter < RootRouter

  def perform
    auth_user
    url = URI.parse @message.payload
    options = Rack::Utils.parse_nested_query url.query
    user.send("#{url.path}!", nil, options)
  end

  # def account_linking
  #   user = User.where(fb_chat_id: @message.sender['id']).first
  #   if user.present?
  #     Action::Generic.new(@message.sender['id']).please_select_role
  #     # Action::Passenger.new(@message.sender['id']).how_can_help_you
  #   else
  #     FbMessage.new(@message.sender['id']).account_link.deliver
  #   end
  # end
end
