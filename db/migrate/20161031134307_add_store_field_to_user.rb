class AddStoreFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :store, :json, null: false, default: {}
  end
end
