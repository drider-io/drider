class ReplyGeneric
  def initialize(socket)
    @sock = socket
    @reply = {}
  end

  def send
    @sock.send_data @reply.to_json
  end

  def start_webview(url:, show_on_locked_screen: false)
    @reply[:webview] = url
    @reply[:show_on_locked_screen] = show_on_locked_screen
    self
  end

  def stop_client
    @reply[:stop_client] = true
    self
  end

  def off_client
    @reply[:off_client] = true
    self
  end


  def handshake_reply
    @reply[:handshake_reply] = true
    self
  end

  def set_text(str)
    @reply[:text] = str
    self
  end

  def play_sound(sound_type: )
    if %w(ringtone notification alarm).include?(sound_type)
      @reply[:play_sound] = sound_type
    end
    self
  end

  def stop_sound
    @reply[:stop_sound] = true
    self
  end

  def exec_js(js)
    @reply[:exec_js] = js
    self
  end

  def location_ack(location_time_id)
    @reply[:ack] = location_time_id
    self
  end

  def as_json(*arg)
    @reply.as_json(*arg)
  end

  def to_hash
    @reply
  end
end
