class CreateCarSearches < ActiveRecord::Migration
  def change
    create_table :car_searches do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :scheduled_to
      t.string :from_title
      t.string :to_title
      t.boolean :pinned
      t.st_point :from_m
      t.st_point :to_m

      t.timestamps null: false
    end
  end
end
