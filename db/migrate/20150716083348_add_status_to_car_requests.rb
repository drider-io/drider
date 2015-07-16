class AddStatusToCarRequests < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE request_status AS ENUM ('sent', 'accepted', 'confirmed', 'ride', 'finished', 'canceled');
    SQL

    change_column :car_requests, :status, "request_status USING 'sent'::request_status"
  end

  def down
    change_column :car_requests, :status, 'integer USING 0'

    execute <<-SQL
      DROP TYPE request_status;
    SQL
  end
end
