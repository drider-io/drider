class DriverNotifier
  def initialize(driver)
    @driver = driver
  end

  def perform
    message = FbMessage.new(@driver.fb_chat_id)

    CarRequest
      .where(driver: @driver, status: ['sent'])
      .includes(:car_search, :passenger)
      .each do |request|
        message.generic_template(title: "Запит від #{request.passenger.name}",
                               subtitle: "підвезти від #{request.from_title} до #{request.to_title}",
                               image_url: request.passenger.image_url191,
                               buttons: [{
                                           type: 'postback',
                                           title: 'Так',
                                           payload: "d_accept?req=#{request.id}"
                                         },
                                         {
                                           type: 'postback',
                                           title: 'Ні',
                                           payload: "d_decline?req=#{request.id}"
                                         },                               ])
    end
    message.deliver
  end
end
