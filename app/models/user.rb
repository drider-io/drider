class User < ActiveRecord::Base
  has_many :car_sessions
  has_many :car_routes
end
