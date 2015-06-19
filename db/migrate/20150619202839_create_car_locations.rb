class CreateCarLocations < ActiveRecord::Migration
  def change
    create_table :car_locations do |t|
      t.st_point :r, geographic: true
      t.st_point :m, srid: 3857
      t.belongs_to :session, index: true, null: false
      t.float :accuracy
      t.timestamp :time, null: false
      t.string :provider
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
