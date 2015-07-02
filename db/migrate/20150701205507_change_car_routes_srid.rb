class ChangeCarRoutesSrid < ActiveRecord::Migration
  def change
    drop_table :car_routes
    create_table :car_routes do |t|
      t.line_string :route, srid: 3785
      t.belongs_to :user, null: false
      t.boolean :is_actual, null: false, default: true, index: true
      t.timestamps null: false
    end
  end
end
