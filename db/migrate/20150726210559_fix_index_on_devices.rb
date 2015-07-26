class FixIndexOnDevices < ActiveRecord::Migration
  def change
    remove_index :devices, [:user_id, :push_type]
    add_index :devices, [:user_id, :push_type, :token], unique: true
  end
end
