class ReplyGeneric
  def initialize
    raise "abstract class"
  end

  def send(sock)
    sock.send_data @hash.to_json
  end
end