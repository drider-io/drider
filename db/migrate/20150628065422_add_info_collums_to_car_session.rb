class AddInfoCollumsToCarSession < ActiveRecord::Migration
  def change
    add_column :car_sessions, :android_model, :string
    add_column :car_sessions, :is_gps_available, :boolean
    add_column :car_sessions, :is_location_enabled, :boolean
    add_column :car_sessions, :is_location_available, :boolean
    add_column :car_sessions, :is_google_play_available, :boolean
    add_column :car_sessions, :android_sdk, :integer
    add_column :car_sessions, :android_manufacturer, :string
    add_column :car_sessions, :client_version_code, :integer
  end
end
