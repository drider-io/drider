class AddUniqueIndexToCarSession < ActiveRecord::Migration
  def up
    add_index :car_sessions, [:number, :user_id], unique: true, :name=>'car_session_user_index'
  end

  def down
    remove_index :car_sessions, 'car_session_user_index'
  end
end
