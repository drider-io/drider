class CarRequest < ActiveRecord::Base
  enum status: [:sent, :accepted, :confirmed, :ride, :finished, :canceled]

  belongs_to :driver, class_name: 'User'
  belongs_to :passenger, class_name: 'User'
  has_many :messages
  belongs_to :car_route

  after_create do
    ActiveSupport::Notifications.instrument('car_request_created', request: self)
  end

end
