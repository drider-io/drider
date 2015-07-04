class AddCarRouteIdToCarSession < ActiveRecord::Migration
  def change
    add_column :car_sessions, :car_route_id, :integer
    add_foreign_key :car_sessions, :car_routes
    add_index :car_sessions, :processed
  end
end
