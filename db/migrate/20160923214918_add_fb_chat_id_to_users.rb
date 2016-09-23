class AddFbChatIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_chat_id, :string
  end
end
