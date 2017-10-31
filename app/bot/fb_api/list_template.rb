module FbApi
  module ListTemplate
    def list_template(title:, subtitle: nil, image_url: nil, buttons: nil, default_action: nil)
      @message.deep_merge!(
        message:{
          attachment:{
            type: "template",
            payload: {
              template_type: "list",
              top_element_style: "compact"
            }
          }
        }
      )
      @message[:message][:attachment][:payload][:elements] ||= []

      em = {title: title}
      em[:subtitle] = subtitle if subtitle
      em[:image_url] = image_url if image_url
      em[:buttons] = FbApi::Buttons.get(buttons) if buttons
      em[:default_action] = default_action if default_action

      @message[:message][:attachment][:payload][:elements] << em

      self
    end

    def list_template_global_button(button)
      @message[:message][:attachment][:payload][:buttons] = [button]
    end
  end
end
