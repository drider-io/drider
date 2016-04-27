class CarSession < ActiveRecord::Base
  belongs_to :user
  has_many :car_locations

  def self.for_user(user, params)
    session = where(user: user).order(:id).last
    last_location = session ? session.car_locations.last : nil
    time = last_location.try(:created_at) || session.try(:created_at)
    if time && time > Time.now - 15.minutes
      session
    else
      build(user, params)
    end
  end

  private

  def self.build(user, params)
    session = new(
        user: user,
        number: Time.now.to_i
    )
    session.device_identifier = params['device_identifier']
    session.client_version = params['client_version']
    session.client_os_version = params['client_os_version']
    session.android_model = params['android_model']
    session.is_gps_available = params['is_gps_available']
    session.is_location_enabled = params['is_location_enabled']
    session.is_location_available = params['is_location_available']
    session.is_google_play_available = params['is_google_play_available']
    session.android_sdk = params['android_sdk']
    session.android_manufacturer = params['android_manufacturer']
    session.client_version_code = params['client_version_code']
    session.save!
    session
  end
end
