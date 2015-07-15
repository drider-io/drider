class AddContstrainsToCarRequest < ActiveRecord::Migration
  def change
    change_column_null :car_requests, :status, false
    change_column_null :car_requests, :driver_id, false
    change_column_null :car_requests, :passenger_id, false
    change_column_null :car_requests, :pickup_location, false
    change_column_null :car_requests, :drop_location, false
    change_column_null :car_requests, :pickup_address, false
    change_column_null :car_requests, :drop_address, false
  end
end
