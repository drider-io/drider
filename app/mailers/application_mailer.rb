class ApplicationMailer < ActionMailer::Base
  default from: "email@drider.io"
  layout 'mailer'

  self.delivery_method = :smtp
  self.smtp_settings = Rails.configuration.mailgun
end
