# Facebook::Messenger.configure do |config|
#   config.access_token = ENV['facebook_page_access_token']
#   config.app_secret = ENV['facebook_app_secret']
#   config.verify_token = ENV['facebook_bot_verify_token']
# end
ENV['ACCESS_TOKEN'] = ENV['facebook_page_access_token']
ENV['APP_SECRET'] = ENV['facebook_app_secret']
ENV['VERIFY_TOKEN'] = ENV['facebook_bot_verify_token']

include Facebook::Messenger
Bot.on :message do |message| MessagesRouter.new(message).perform end
Bot.on :postback do |message| PostbacksRouter.new(message).perform end
# Bot.on :optin do |message| FbRouter.new(message).perform end
Bot.on :optin do |optin|
  p "optin"
  p optin
end
Bot.on :referral do |message| ReferralRouter.new(message).perform end
Bot.on :message_echo do |message_echo|
  p "message_echo"
  p message_echo
end
Bot.on :delivery do |delivery|
  p "delivery"
  p delivery
end
Bot.on :read do |read|
  p "read"
  p read
end

Bot.on :account_linking do |message| PostbacksRouter.new(message).account_linking end

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

