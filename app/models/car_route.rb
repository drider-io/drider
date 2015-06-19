class CarRoute < ActiveRecord::Base
  belongs_to :user
  has_many :car_route_stats
end
