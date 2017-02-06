module FbApi
  module TextMessage
    def text_message(text)
      @message.merge!(
        message: {
          text: text,
        }
      )
      self
    end
  end
end
