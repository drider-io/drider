json.array!(@car_requests) do |car_request|
  json.extract! car_request, :id, :status, :scheduled_to, :driver_id_id, :passenger_id_id, :from_m, :to_m, :from_title, :to_title
  json.url car_request_url(car_request, format: :json)
end
