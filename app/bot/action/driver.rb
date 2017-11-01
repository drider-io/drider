class Action::Driver
  def initialize(fb_chat_id)
    @fb_chat_id = fb_chat_id
  end

  # def please_install_app
  #   FbMessage.new(@fb_chat_id)
  #     .button_template(text: 'Чудово, наступний крок записати маршрут(и) за яким ви можете підвезти. Встановіть мобільний додаток і запишіть маршрут.',
  #                      buttons: [:app_ios, :app_android])
  #     .deliver
  # end

  def please_record_a_route
    FbMessage.new(@fb_chat_id)
      .button_template(text: 'Скористуйтесь мобільним застосунком, аби записати маршрут',buttons: [:download])
      .deliver
  end

  def please_keep_recording
    FbMessage.new(@fb_chat_id)
      .button_template(text: 'Продовжуйте записувати маршрути', buttons: [:download])
      .deliver
  end

  def driver_default(user)
    if user.car_routes.actual.count > 0
      FbMessage.new(@fb_chat_id)
        .button_template(text: "Маршрутів: #{user.car_routes.actual.count}",
                         buttons: [add_route_button(user), show_routes_button(user)]).deliver
    else
      FbMessage.new(@fb_chat_id)
        .button_template(text: 'Додайти маршрути за якими вас можуть знайти пасажири',
                         buttons: [add_route_button(user)]).deliver
    end
  end

  private

  def add_route_button(user)
    {
      type: 'web_url',
      title: 'Додати маршрут',
      url: Rails.application.routes.url_helpers.new_route_url + "?auth_token=#{user.authentication_token}",
    }
  end

  def show_routes_button(user)
    {
      type: 'web_url',
      title: 'Переглянути маршрути',
      url: Rails.application.routes.url_helpers.routes_url + "?auth_token=#{user.authentication_token}",
    }
  end
end
