class SetSridForCarSearches < ActiveRecord::Migration
  def up
    drop_table :car_searches
    create_table :car_searches do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :scheduled_to
      t.string :from_title
      t.string :to_title
      t.boolean :pinned
      t.st_point :from_m, srid: 3785
      t.st_point :to_m, srid: 3785

      t.timestamps null: false
    end

  end
end
