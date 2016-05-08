class ChangeUsersDriverRoleToDefaultNull < ActiveRecord::Migration
  def change
    change_column :users, :driver_role, :boolean, default: nil, null: true
  end
end
