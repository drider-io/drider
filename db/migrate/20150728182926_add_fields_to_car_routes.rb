class AddFieldsToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :from_m, :st_point, srid: 3785
    add_column :car_routes, :to_m, :st_point, srid: 3785
    add_column :car_routes, :from_address, :string
    add_column :car_routes, :to_address, :string
  end
end
