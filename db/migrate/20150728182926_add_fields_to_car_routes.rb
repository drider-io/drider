class AddFieldsToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :from_m, :st_point, srid: 3857
    add_column :car_routes, :to_m, :st_point, srid: 3857
    add_column :car_routes, :from_title, :string
    add_column :car_routes, :to_title, :string
  end
end
