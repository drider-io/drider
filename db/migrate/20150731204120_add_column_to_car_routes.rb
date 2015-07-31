class AddColumnToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :driven_at, :datetime
  end
end
