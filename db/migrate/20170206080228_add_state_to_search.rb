class AddStateToSearch < ActiveRecord::Migration
  def change
    add_column :car_searches, :state, :string, default: 'new'
  end
end
