FactoryGirl.define do
  factory :car_location do
    user
    accuracy 5
    time Time.now - 20.minutes
    created_at Time.now - 20.minutes
    location_time Time.now - 20.minutes
  end
end
