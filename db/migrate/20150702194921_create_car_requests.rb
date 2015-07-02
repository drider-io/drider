class CreateCarRequests < ActiveRecord::Migration
  def up
    create_table :car_requests do |t|
      t.integer :status
      t.datetime :scheduled_to
      t.integer :driver_id, index: true
      t.integer :passenger_id, index: true
      t.st_point :from_m, srid: 3785
      t.st_point :to_m, srid: 3785
      t.string :from_title
      t.string :to_title

      t.timestamps null: false
    end

    add_foreign_key :car_requests, :users, {column: :driver_id}
    add_foreign_key :car_requests, :users, {column: :passenger_id}
  end

  def down
    drop_table :car_requests
  end
end
