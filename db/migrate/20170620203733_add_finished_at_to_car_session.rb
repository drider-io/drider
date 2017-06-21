class AddFinishedAtToCarSession < ActiveRecord::Migration
  def change
    add_column :car_sessions, :finished_at, :datetime
  end
end
