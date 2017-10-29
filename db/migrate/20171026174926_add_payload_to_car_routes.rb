class AddPayloadToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :payload, :jsonb
  end
end
