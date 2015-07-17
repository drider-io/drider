class ChangeDateTimeToTimeCarRequests < ActiveRecord::Migration
  def change
    change_column_null :car_searches, :time, false
  end
end
