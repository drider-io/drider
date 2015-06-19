class CreateCarRoutes < ActiveRecord::Migration
  def change
    create_table :car_routes do |t|
      t.line_string :route, srid: 3857
      t.belongs_to :user, null: false
      t.boolean :is_actual, null: false, default: true, index: true
      t.timestamps null: false
    end
  end
end
