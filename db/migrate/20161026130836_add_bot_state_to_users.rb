class AddBotStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bot_state, :string
  end
end
