class CreateDetailsLogs < ActiveRecord::Migration
  def change
    create_table :details_logs do |t|
      t.references :parent, polymorphic: true, index: true
      t.text :info, default: '', null: false
      t.timestamps null: false
    end
  end
end
