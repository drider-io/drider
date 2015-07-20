class MessageGenerator
  def on_car_request_created(car_request)
    day = (car_request.scheduled_to.to_date == Time.now.to_date) ? 'сьогодні' : 'завтра'
    Message.create(
               from: car_request.passenger,
               to: car_request.driver,
               car_request: car_request,
               body: <<TEXT
Привіт, підвезеж з #{car_request.pickup_address} до #{car_request.drop_address}, #{day} о #{car_request.scheduled_to.to_formatted_s(:time) } ?
TEXT
    )
  end
end