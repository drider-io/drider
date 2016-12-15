class DriverNotifier
  def initialize(driver)
    @driver_id = driver.id
  end

  def perform
    CarRequest
      .where(driver_id: @driver_id, status: ['sent'])
      .includes(:car_search, :passenger)
      .each do |request|
      FbMessage
        .new(request.driver.fb_chat_id)
        .generic_template(title: "Запит від #{request.passenger.name}",
                          subtitle: "підвезти від #{request.from_title} до #{request.to_title}",
                          image_url: request.passenger.image_url191,
                          buttons: [:d_accept, :d_decline])
        .deliver
    end
  end
end
