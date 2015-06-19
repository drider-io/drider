class User < ActiveRecord::Base
  has_many :car_sessions
end
