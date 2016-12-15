class RemoveCarRequestContraints < ActiveRecord::Migration
  def change
    change_column_null :car_requests, :scheduled_to, true
    change_column_null :car_requests, :pickup_location, true
    change_column_null :car_requests, :drop_location, true
    change_column_null :car_requests, :pickup_address, true
    change_column_null :car_requests, :drop_address, true
    change_column_null :car_requests, :car_route_id, true
    change_column_null :car_requests, :active_user_id, true
  end
end
