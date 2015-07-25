class AddUniqToRpushTable < ActiveRecord::Migration
  def change
    add_index :rpush_apps, :name, uniq: true
  end
end
