class ReplyGeneric
  def initialize(transport)
    @transport = transport
    @reply = {}
  end

  def send
    if @transport.is_a? User
      Redis.new.publish "user_#{@transport.id}", @reply.to_json
    else
      @transport.send_data @reply.to_json
    end
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

  def session_length(session)
    @reply[:session_length] = session.length.to_i.to_s
    self
  end

  def location_ack(location_time_id)
    @reply[:ack] = location_time_id
    self
  end

  def set_auth_token(token)
    @reply[:set_auth_token] = token
    self
  end

  def routes_count(count)
    @reply[:routes_count] = count
    self
  end

  def status_label(value)
    @reply[:status_label] = value
    self
  end

  def account_linked(value)
    @reply[:account_linked] = value
    self
  end

  def as_json(*arg)
    @reply.as_json(*arg)
  end

  def to_hash
    @reply
  end
end
