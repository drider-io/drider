class ChangeSrid < ActiveRecord::Migration
  def up
    drop_table :car_locations
    create_table :car_locations do |t|
      t.st_point :r, geographic: true
      t.st_point :m, srid: 3785
      t.belongs_to :car_session, index: true, null: false
      t.float :accuracy
      t.timestamp :time, null: false
      t.string :provider
      t.belongs_to :user
      t.timestamps null: false
    end
  end

  def down

  end
end
