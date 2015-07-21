class AddActiveUserToCarRequests < ActiveRecord::Migration
  def change
    add_column :car_requests, :active_user_id, :integer, null: false
    add_index :car_requests, :active_user_id
  end
end
