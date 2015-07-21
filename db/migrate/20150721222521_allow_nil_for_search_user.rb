class AllowNilForSearchUser < ActiveRecord::Migration
  def change
    change_column_null :car_searches, :user_id, true
  end
end
