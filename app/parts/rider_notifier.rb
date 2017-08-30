class RiderNotifier
  def initialize(car_search)
    @car_search = car_search
  end

  def perform
    message = FbMessage.new(@car_search.user.fb_chat_id)
    total = @car_search.car_requests.count
    sent = @car_search.car_requests.where(status: ['sent']).count

    accepted = @car_search.car_requests
      .where( status: ['accepted'])
      .includes(:driver).to_a
    accepted.each do |request|
        message.generic_template(title: "#{request.driver.name} може підвезти",
                                 subtitle: "від #{request.from_title} до #{request.to_title}",
                                 image_url: request.driver.image_url191,
                                 buttons: [{
                                             type: 'phone_number',
                                             title: 'Задзвонити',
                                             payload: request.driver.phone
                                           },
                                 ])
      .deliver
    end
    if sent > 0
      message.text_message("Очікуємо на відповідь від #{sent} водіїв з #{total} запитів")
    else
      message.text_message("Пошук завершено")
      @car_search.user.finish_search!
    end
    message.deliver
  end

end
