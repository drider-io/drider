class MessageGenerator
  def on_car_request_created(car_request)
    Message.create(
               from: car_request.passenger,
               to: car_request.driver,
               car_request: car_request,
               body: <<TEXT
Привіт, підвезеж з #{car_request.pickup_address} до #{car_request.drop_location} ?
TEXT
    )
  end
end