class AddContstrainsToCarSearches < ActiveRecord::Migration
  def change
    change_column_null :car_searches, :user_id, false
    change_column_null :car_searches, :from_title, false
    change_column_null :car_searches, :to_title, false
    change_column_null :car_searches, :pinned, false
    change_column_null :car_searches, :from_m, false
    change_column_null :car_searches, :to_m, false
  end
end
