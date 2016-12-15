class AddRequestStatusValues < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def up
    execute <<-SQL
      ALTER TYPE request_status ADD VALUE 'declined';
    SQL
    execute <<-SQL
      ALTER TYPE request_status ADD VALUE 'expired';
    SQL
  end
end
