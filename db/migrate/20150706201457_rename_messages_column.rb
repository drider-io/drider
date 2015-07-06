class RenameMessagesColumn < ActiveRecord::Migration
  def change
    rename_column :messages, :car_request, :car_request_id
    add_foreign_key :messages, :car_requests
  end
end
