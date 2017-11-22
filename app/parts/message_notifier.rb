class MessageNotifier
  def initialize(user)
    @user = user
  end

  def perform
    message = FbMessage.new(@user.fb_chat_id)

    corespondent_ids = Message.unread(@user).distinct.group('from_id').pluck(:from_id,'max(created_at)').sort_by(&:last).reverse

    corespondent_ids.first(10).each do |ar|
      origin = User.find(ar.first)
      message.generic_template(title: "Повідомлення від #{origin.name}",
                               subtitle: Message.where(from_id: origin.id, to_id: @user.id).order('created_at DESC').first.body,
                               image_url: origin.image_url191,
                               buttons: [
                                         {
                                           type: 'web_url',
                                           title: 'Повідомлення',
                                           url: Rails.application.routes.url_helpers.message_url(origin.id) + "?auth_token=#{origin.authentication_token}",
                                         }
                               ])
    end
    message.deliver
  end
end
