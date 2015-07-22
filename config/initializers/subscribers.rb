ActiveSupport::Notifications.subscribe('car_request_changed') do |name, start, ending, transaction_id, payload|
  MessageGenerator.new.on_car_request_changed(payload[:request])
end