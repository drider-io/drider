class AddOptimisticLockingToCarSessions < ActiveRecord::Migration
  def change
    add_column :car_sessions, :lock_version, :integer
  end
end
