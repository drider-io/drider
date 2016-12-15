module FbApi
  module GenericTemplate
    def generic_template(title:, url: nil, image_url: nil, subtitle: nil, buttons: nil)
      @message.deep_merge!(
        message:{
          attachment:{
            type:"template",
            payload:{
              template_type:"generic",
            }
          }
        }
      )
      @message[:message][:attachment][:payload][:elements] ||= []

      em = {title: title}
      em[:url] = url if url
      em[:image_url] = image_url if image_url
      em[:subtitle] = subtitle if subtitle
      em[:buttons] = FbApi::Buttons.get(buttons) if buttons
      @message[:message][:attachment][:payload][:elements] << em

      self
    end
  end
end
