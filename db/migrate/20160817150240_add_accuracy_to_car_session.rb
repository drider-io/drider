class AddAccuracyToCarSession < ActiveRecord::Migration
  def change
    add_column :car_sessions, :accurate, :boolean, default: true, null: false
  end
end
