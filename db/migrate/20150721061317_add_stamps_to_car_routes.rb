class AddStampsToCarRoutes < ActiveRecord::Migration
  def change
    add_column :car_routes, :started_at, :datetime, null: false
    add_column :car_routes, :finished_at, :datetime, null: false
  end
end
