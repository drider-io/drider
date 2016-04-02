class ExternalNotificationGenerator


  def on_message_saved(message)
    push_notifications(message)
    publish_notification(message)
  end

  private

  def publish_notification(message)
    Redis.new.publish "user_#{message.to.id}", {from: message.from.id}
  end


  def push_notifications(message)
    text = "Повідомлення від #{message.from.name}"
    command = ReplyGeneric.new(nil)
                  .start_webview(url: Rails.application.routes.url_helpers.message_url(message.from_id)+'#body')
                  .play_sound(sound_type: 'notification')
    message.to.devices.each do |device|
      case device.push_type
        when 'GCM'
          n = Rpush::Gcm::Notification.new
          n.app = Rpush::Gcm::App.find_by_name("android_app")
          n.registration_ids = [device.token]
          n.data = { title: text, payload: command.to_json }
          n.save!
        when 'APN'
          n = Rpush::Apns::Notification.new
          n.app = Rpush::Apns::App.find_by_name("ios_app")
          n.device_token = device.token
          n.alert = text
          n.data = command.to_hash
          n.save!
        else

      end
    end
  end

end
