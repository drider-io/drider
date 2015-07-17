class ChangeDateTimeToTime < ActiveRecord::Migration
  def change
    rename_column :car_searches, :scheduled_to, :time
    change_column :car_searches, :time, :time
  end
end
