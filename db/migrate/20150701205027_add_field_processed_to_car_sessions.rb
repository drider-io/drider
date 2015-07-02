class AddFieldProcessedToCarSessions < ActiveRecord::Migration
  def change
    add_column :car_sessions, :processed, :boolean, default: false
  end
end
