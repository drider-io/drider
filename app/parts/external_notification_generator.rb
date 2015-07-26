class ExternalNotificationGenerator


  def on_message_saved(message)
    text = "Повідомлення від #{message.from.name}"
    command = ReplyGeneric.new(nil)
                  .start_webview(url: Rails.application.routes.url_helpers.message_url(message.from_id))
                  .play_sound(sound_type: 'notification')

    message.to.devices.each do |device|
      case device.push_type
        when 'GCM'
          n = Rpush::Gcm::Notification.new
          n.app = Rpush::Gcm::App.find_by_name("android_app")
          n.registration_ids = [device.token]
          n.data = { title: text, payload: command.to_json }
          n.save!
        else

      end
    end


  end

end