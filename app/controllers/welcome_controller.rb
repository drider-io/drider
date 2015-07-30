class WelcomeController < ApplicationController
  def index
    p current_user
  end

  def entry
    if current_user
      if current_user.driver_role && !current_user.ever_drive
        redirect_to route_required_account_url
      else
        redirect_to messages_url
      end
    else
      redirect_to welcome_url
    end
  end

  def mail
    ActionMailer::Base.mail(
            from: '700@2rba.com',
            to: 'reports@mx.2rba.com',
             body: params[:email]+ ' ' + params[:body],
             content_type: "text/plain",
             subject: 'Drider mail form'
    ).deliver
    redirect_to :welcome, notice: "Дякуємо за звернення"
  end

  def events
    render :json => RecentEventsSerializer.new(RecentEventsService.new)
  end
end