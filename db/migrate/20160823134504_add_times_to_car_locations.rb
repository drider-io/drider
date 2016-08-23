class AddTimesToCarLocations < ActiveRecord::Migration
  def change
    add_column :car_locations, :time_id, :bigint, default: nil, null: true
    add_column :car_locations, :location_time, 'double precision', default: nil, null: true
    add_column :car_locations, :queue_time, 'double precision', default: nil, null: true
    add_column :car_locations, :send_time, 'double precision', default: nil, null: true

    add_index :car_locations, [:user_id, :time_id], unique: true
  end
end
