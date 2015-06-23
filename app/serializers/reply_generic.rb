class ReplyGeneric
  def initialize(socket)
    @sock = socket
    @reply = {}
  end

  def send
    @sock.send_data @reply.to_json
  end

  def start_webview(url:)
    @reply[:webview] = url
    self
  end

  def stop_client
    @reply[:stop_client] = true
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

end