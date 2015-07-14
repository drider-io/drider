class AddRouteIdToCarRequest < ActiveRecord::Migration
  def change
    add_column :car_requests, :car_route_id, :integer
    add_foreign_key :car_requests, :car_routes
  end
end
