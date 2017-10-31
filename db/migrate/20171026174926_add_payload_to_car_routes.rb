class AddPayloadToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :payload, :json
  end
end
