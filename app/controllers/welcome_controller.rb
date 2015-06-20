class WelcomeController < ApplicationController
  def index
    p current_user
  end
end