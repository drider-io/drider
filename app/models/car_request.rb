class CarRequest < ActiveRecord::Base
  enum status: [:sent, :accepted, :confirmed, :ride, :finished, :canceled]

  belongs_to :driver, class: 'User'
  belongs_to :passenger, class: 'User'
  has_many :messages

  after_create do
    ActiveSupport::Notifications.instrument('car_request_created', request: self)
  end

end
