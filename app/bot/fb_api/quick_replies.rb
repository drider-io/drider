module FbApi
  module QuickReplies
    def quick_replies(text:, replies: )
      @message.merge!(
        message: {
          text: text,
          quick_replies: map_replies(replies)
        }
      )
      self
    end

    private

    def map_replies(*replies)
      replies.flatten.map do |reply|
        case reply
          when :location
            {
              content_type: "location",
            }
          else
            reply
        end
      end
    end
  end
end
