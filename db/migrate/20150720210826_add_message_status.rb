class AddMessageStatus < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE delivery_status AS ENUM ('sent', 'delivered', 'read');
    SQL

    add_column :messages, :delivery_status, :delivery_status, default: 'sent', null: false
    add_column :car_requests, :delivery_status, :delivery_status, default: 'sent', null: false
  end

  def down
    remove_column :messages, :delivery_status
    remove_column :car_requests, :delivery_status

    execute <<-SQL
      DROP TYPE delivery_status;
    SQL
  end
end
