class WelcomeController < ApplicationController
  def index
    p current_user
  end

  def entry
    if current_user
      redirect_to messages_url
    else
      redirect_to welcome_url
    end
  end
end