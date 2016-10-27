module FbApi
  module ButtonTemplate
    def button_template(text:, buttons: )
      @message.merge!(
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: text,
              buttons: FbApi::Buttons.get(buttons)
            }
          }
        }
      )
      self
    end
  end
end
