ActiveSupport::Notifications.subscribe('car_request_created') do |name, start, ending, transaction_id, payload|
  MessageGenerator.new.on_car_request_created(payload[:request])
end