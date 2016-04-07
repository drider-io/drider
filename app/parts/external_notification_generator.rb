class ExternalNotificationGenerator


  def on_message_saved(message)
    push_notifications(message)
    publish_notification(message)
  end

  private

  def publish_notification(message)
    pub_msg = reload_command(message).to_json
    Redis.new.publish "user_#{message.to.id}", pub_msg
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
          n.save #TODO refactor with catch errors
        when 'APN'
          n = Rpush::Apns::Notification.new
          n.app = Rpush::Apns::App.find_by_name("ios_app")
          n.device_token = device.token
          n.alert = text
          n.badge = badge(message.to)
          n.data = reload_command(message).to_hash
          n.save #TODO refactor with catch errors
        else

      end
    end
  end

  private

  def reload_command(message)
    ReplyGeneric.new(nil).exec_js("on_message(#{message.from.id.to_i})")
  end

  def badge(current_user)
    CarRequest.unread(current_user).count + Message.unread(current_user).count
  end
end
