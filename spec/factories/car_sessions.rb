FactoryGirl.define do
  factory :car_session do
    number 11
    device_identifier 'iPhone'
    client_version '1.2'
    client_os_version '9'
  end

  factory :car_session_params, class: Hash do
    client_version '1.2'
    client_os_version '9'
    client_version_code '22'
    device_identifier '2222'

    factory :android_car_session_params do
      session_number '1111'
      android_model '2123'
      is_gps_available 'true'
      is_location_enabled 'true'
      is_location_available 'true'
      is_google_play_available 'true'
      android_sdk '1.2'
      android_manufacturer 'Lenovo'
    end

    factory :ios_car_session_params do

    end

    initialize_with { attributes.stringify_keys }
  end
end
