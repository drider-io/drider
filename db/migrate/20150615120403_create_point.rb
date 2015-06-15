class CreatePoint < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.st_point :lonlat, geographic: true
      t.float :accuracy
      t.datetime :time
      t.timestamps
    end
  end
end
