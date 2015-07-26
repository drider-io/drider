class CreateDevices < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE push_type AS ENUM ('GCM', 'APN');
    SQL
    create_table :devices do |t|
      t.belongs_to :user
      t.string :name
      t.column :push_type, :push_type
      t.string :token

      t.timestamps null: false
    end

    add_index :devices, [:user_id, :push_type], :unique => true
  end

  def down
    drop_table :devices

    execute <<-SQL
      DROP TYPE push_type;
    SQL
  end

end
