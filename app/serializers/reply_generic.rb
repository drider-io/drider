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

  def hadshake_reply
    @reply[:handshake_reply] = true
  end

end