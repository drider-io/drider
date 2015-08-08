class AddCarSearchToCarRequest < ActiveRecord::Migration
  def change
    add_column :car_requests, :car_search_id, :integer, null: false
    add_foreign_key :car_requests, :car_searches
    change_column_null :car_requests, :car_route_id, false
  end
end
