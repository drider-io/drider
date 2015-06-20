class CarLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :car_session
end
