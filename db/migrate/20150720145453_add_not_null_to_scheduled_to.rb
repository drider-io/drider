class AddNotNullToScheduledTo < ActiveRecord::Migration
  def change
    change_column_null :car_requests, :scheduled_to, false
  end
end
