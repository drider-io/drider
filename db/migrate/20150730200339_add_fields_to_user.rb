class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :driver_role, :boolean, default: false, null: false
    add_column :users, :ever_drive, :boolean, default: false, null: false
  end
end
