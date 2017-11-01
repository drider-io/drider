class AddDeletedAtToCarRoute < ActiveRecord::Migration
  def change
    add_column :car_routes, :deleted_at, :datetime, index: true
  end
end
