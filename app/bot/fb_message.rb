class FbMessage
  extend Forwardable
  include FbApi::ButtonTemplate

  def_delegator :@message, :to_hash, :to_hash

  def initialize(id)
    @message = {
      recipient: {id: id},
      message: {
      }
    }
  end

  def deliver
    Bot.deliver @message
  end
end
