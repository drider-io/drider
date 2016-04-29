class WelcomeController < ApplicationController
  def index
    p current_user
  end

  def entry
    session[:client] ='ios' if 'ios' == params[:client]
    if current_user
      if warning_required?
        redirect_to device_warning_account_path + '?' + request.env['QUERY_STRING']
      else
        route_helper
      end
    else
      if params[:client]
        redirect_to new_user_session_path
      else
        redirect_to welcome_url
      end
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

  def policy

  end

  private

  def warning_required?
    'ios' == params[:client] &&
        (params[:location] != 'Authorized' || params[:notifications] == '')
  end
end
