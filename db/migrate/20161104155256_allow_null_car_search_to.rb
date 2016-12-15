class AllowNullCarSearchTo < ActiveRecord::Migration
  def change
    change_column_null :car_searches, :to_m, true
    change_column_null :car_searches, :to_title, true

    add_column :users, :last_search_id, :integer
  end
end
