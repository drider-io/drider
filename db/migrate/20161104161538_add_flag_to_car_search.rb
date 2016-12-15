class AddFlagToCarSearch < ActiveRecord::Migration
  def change
    add_column :car_searches, :has_results, :boolean, index: true
    change_column_null :car_searches, :time, true
    change_column_null :car_searches, :pinned, true
  end
end
