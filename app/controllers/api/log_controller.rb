class Api::LogController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    ActionMailer::Base.mail(
            from: '700@2rba.com',
            to: 'reports@mx.2rba.com',
             body: params[:stacktrace],
             content_type: "text/plain",
             subject: 'Drider stacktrace'
    ).deliver
    p 1
    render json: {}
  end
end