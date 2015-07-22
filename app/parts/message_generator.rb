class MessageGenerator
  def on_car_request_changed(car_request)
    case car_request.status
      when 'sent'
        day = (car_request.scheduled_to.to_date == Time.now.to_date) ? 'сьогодні' : 'завтра'
        txt = <<TEXT
Привіт, підвезеж з #{car_request.pickup_address} до #{car_request.drop_address}, #{day} о #{car_request.scheduled_to.to_formatted_s(:time) } ?
TEXT
      when 'accepted'
        txt = <<TEXT
Гаразд, зможу підвезти.
TEXT
      when 'confirmed'
        txt = <<TEXT
Домовились, до зустрічі.
TEXT
      when 'finished'
        txt = <<TEXT
Дякую за поїздку !
TEXT
      when 'canceled'
        txt = <<TEXT
Вибач, передумав.
TEXT
      else
        return
    end


    Message.create(
               from: car_request.cor(car_request.active_user),
               to: car_request.active_user,
               car_request: car_request,
               body: txt
    )
  end
end