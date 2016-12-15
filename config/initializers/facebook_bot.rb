Facebook::Messenger.configure do |config|
  config.access_token = ENV['facebook_page_access_token']
  config.app_secret = ENV['facebook_app_secret']
  config.verify_token = ENV['facebook_bot_verify_token']
end

include Facebook::Messenger
Bot.on :message do |message| MessagesRouter.new(message).perform end
Bot.on :postback do |message| PostbacksRouter.new(message).perform end
# Bot.on :optin do |message| FbRouter.new(message).perform end
# Bot.on :account_linking do |message| FbRouter.new(message).perform end

  # Rails.logger.debug message.inspect
  # Rails.logger.debug  "message.id #{message.id}"          # => 'mid.1457764197618:41d102a3e1ae206a38'
  # Rails.logger.debug  "message.sender #{message.sender}"      # => { 'id' => '1008372609250235' }
  # message.seq         # => 73
  # message.sent_at     # => 2016-04-22 21:30:36 +0200
  # message.text        # => 'Hello, bot!'
  # message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]



  # Bot.deliver(
  #   recipient: message.sender,
  #   message: {
  #     text: 'Hello, human!'
  #   }
  # )

