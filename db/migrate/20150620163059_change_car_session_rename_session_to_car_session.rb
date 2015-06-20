class ChangeCarSessionRenameSessionToCarSession < ActiveRecord::Migration
  def up
    rename_column :car_locations, :session_id, :car_session_id
    rename_column :car_locations, :time, :car_time
  end

  def down
    rename_column :car_locations, :car_session_id, :session_id
    rename_column :car_locations, :car_time, :time
  end
end
