module FbApi::AccountLink
  def account_link
    @message.merge!(
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'generic',
            elements: [{
                         title: 'Привіт, мене звати Драйдер, а вас як ?',
                         image_url: 'http://drider.io/assets/landing/car-bfd8fa3ca5ec5db3757ba8f6a3ec576741d5cc7aee58a0d43a9948338fbe8404.jpg',
                         buttons: [
                           {
                             type: "account_link",
                             url: Rails.application.routes.url_helpers.new_users_login_url,
                           }
                         ]
                       }]
          }
        }
      }
    )
    self
  end
end
