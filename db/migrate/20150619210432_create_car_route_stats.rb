class CreateCarRouteStats < ActiveRecord::Migration
  def change
    create_table :car_route_stats do |t|
      t.belongs_to :car_route, null: false
      t.timestamps :started_at, null: false
      t.timestamps :ended_at, null: false
      t.timestamps null: false
    end
  end
end
