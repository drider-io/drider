class CreateCarSessions < ActiveRecord::Migration
  def change
    create_table :car_sessions do |t|
      t.integer :number, null: false, index: true
      t.string :device_identifier, null: false
      t.string :client_version, null: false
      t.string :client_os_version, null: false
      t.belongs_to :user, null: false
      t.timestamps null: false
    end
  end
end
