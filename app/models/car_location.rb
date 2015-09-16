class CarLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :car_session

  scope :accurate, -> { where('accuracy < 20') }
end
