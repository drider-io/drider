class Action::Passenger
  def initialize(fb_chat_id)
    @fb_chat_id = fb_chat_id
  end

  def provide_from
    FbMessage.new(@fb_chat_id).quick_replies(text: 'Звідки: вкажіть координату', replies: :location).deliver
  end

  def provide_another_from
      FbMessage.new(@fb_chat_id).quick_replies(text: 'На жаль, звідси ніхто не може підвезти', replies: :location).deliver
  end

  def provide_to
    FbMessage.new(@fb_chat_id).quick_replies(text: 'Куди: вкажіть координату', replies: :location).deliver
  end

  def location_only
    FbMessage.new(@fb_chat_id).quick_replies(text: 'На разі тільки координата (можна відправити з мобільного)', replies: :location).deliver
  end

  def drivers_found(count)
    FbMessage.new(@fb_chat_id).button_template(text: "Знайдено #{count} водіїв, коли іхати ?", buttons: [:go_now, :p_cancel]).deliver
  end

  def provide_another_to
    FbMessage.new(@fb_chat_id).quick_replies(text: 'На жаль, сюди ніхто не може підвезти', replies: :location).deliver
  end

  def how_can_help_you
    FbMessage.new(@fb_chat_id)
      .button_template(text: 'Чим можу допомогти ?', buttons: [:go])
      .deliver
  end

  def ok
    FbMessage.new(@fb_chat_id).quick_replies(text: 'ok', replies: :location).deliver
  end

  def canceled
    FbMessage.new(@fb_chat_id).quick_replies(text: 'Відмінено', replies: :location).deliver
  end

  def please_wait
    FbMessage.new(@fb_chat_id).quick_replies(text: 'Запити надіслано, зачекайте будь ласка', replies: :location).deliver
  end
end
