class CarSession < ActiveRecord::Base
  belongs_to :user
  has_many :car_locations
end
