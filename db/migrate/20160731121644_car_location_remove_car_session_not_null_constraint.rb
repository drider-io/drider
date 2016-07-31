class CarLocationRemoveCarSessionNotNullConstraint < ActiveRecord::Migration
  def change
    change_column :car_locations, :car_session_id, :integer, null: true
  end
end
