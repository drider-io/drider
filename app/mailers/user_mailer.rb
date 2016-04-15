class UserMailer < ApplicationMailer
  default 'X-Mailgun-Tag' => 'generic'

  def welcome(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Welcome to Drider.io')
  end
end
