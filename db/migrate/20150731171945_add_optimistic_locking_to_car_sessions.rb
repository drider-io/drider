class AddOptimisticLockingToCarSessions < ActiveRecord::Migration
  def change
    add_column :car_sessions, :lock_version, :integer, default: 0, null:false
  end
end
