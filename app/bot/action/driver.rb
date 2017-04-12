class Action::Driver
  def initialize(fb_chat_id)
    @fb_chat_id = fb_chat_id
  end

  def please_install_app
    FbMessage.new(@fb_chat_id)
      .button_template(text: 'Чудово, наступний крок записати маршрут(и) за яким ви можете підвезти. Встановіть мобільний додаток і запишіть маршрут.',
                       buttons: [:app_ios, :app_android])
      .deliver
  end

  def please_record_a_route
    FbMessage.new(@fb_chat_id)
      .text_message('Ви маєте встановлений додаток, скористуйтсь їм аби записати маршрут')
      .deliver
  end
end
