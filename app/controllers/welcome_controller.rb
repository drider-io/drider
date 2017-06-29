class WelcomeController < ApplicationController
  def index
    p current_user
  end

  def entry
    redirect_to welcome_url
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

  def policy

  end

  def profile_picture
    redirect_to "https://graph.facebook.com/#{params[:id]}/picture?height=450"
  end

  private

  def warning_required?
    'ios' == params[:client] &&
        (params[:location] != 'Authorized' || params[:notifications] == '')
  end
end
