class PhonesController < ApplicationController
  def new
    @user = current_user
  end

  def update
    current_user.update(phone: params.require(:user)[:phone])
    FbMessage.new(current_user.fb_chat_id).text_message('Телефон додано').deliver
    if CarRequest.where(driver: current_user, status: ['sent']).count > 0
      FbMessage.new(current_user.fb_chat_id).text_message('Будь-ласка, ще раз підтвердіть свою згоду підвезти').deliver
      DriverNotifier.new(current_user).perform
    end
    render json: {}
  end
end
