class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_id, index: true
      t.integer :to_id, index: true
      t.integer :car_request, index: true, foreign_key: true
      t.string :body
      t.datetime :seen_at

      t.timestamps null: false
    end
    add_foreign_key :messages, :users, {column: :from_id}
    add_foreign_key :messages, :users, {column: :to_id}

  end
end
