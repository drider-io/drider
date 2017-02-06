class FbMessage
  extend Forwardable
  include FbApi::ButtonTemplate
  include FbApi::QuickReplies
  include FbApi::AccountLink
  include FbApi::GenericTemplate
  include FbApi::TextMessage

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
