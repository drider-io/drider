class CarRequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :scheduled_to, :from_m, :to_m, :from_title, :to_title
end
  attribute :driver_id
  attribute :passenger_id
