class Action::Generic
  def initialize(fb_chat_id)
    @fb_chat_id = fb_chat_id
  end

  def please_select_role
    FbMessage.new(@fb_chat_id)
      .button_template(text: 'Хто ви ?', buttons: [:select_rider, :select_driver])
      .deliver
  end
end
