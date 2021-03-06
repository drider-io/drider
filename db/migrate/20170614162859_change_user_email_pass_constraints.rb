class ChangeUserEmailPassConstraints < ActiveRecord::Migration
  def change
    change_column_null :users, :email, true
    change_column_null :users, :encrypted_password, true

    change_column_default :users, :email, nil
    change_column_default :users, :encrypted_password, nil
  end
end
