class ChangeCarSessionIsGoogleServiceAvailable < ActiveRecord::Migration
  def up
    change_column :car_sessions, :is_google_play_available, 'integer USING CAST(is_google_play_available AS integer)'
  end

  def down
    change_column :car_sessions, :is_google_play_available, :boolean
  end
end
