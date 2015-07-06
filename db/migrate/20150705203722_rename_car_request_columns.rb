class RenameCarRequestColumns < ActiveRecord::Migration
  def change
    rename_column :car_requests, :from_m, :pickup_location
    rename_column :car_requests, :to_m, :drop_location
    rename_column :car_requests, :from_title, :pickup_address
    rename_column :car_requests, :to_title, :drop_address
  end
end
