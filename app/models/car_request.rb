class CarRequest < ActiveRecord::Base
  enum status: [:sent, :accepted, :confirmed, :ride, :finished, :canceled]

  belongs_to :driver, class_name: 'User'
  belongs_to :passenger, class_name: 'User'
  has_many :messages
  belongs_to :car_route

  after_create do
    ActiveSupport::Notifications.instrument('car_request_created', request: self)
  end

  scope :with_user, ->(user) {
    r = arel_table
    where(r[:driver_id].eq(user.id).or(r[:passenger_id].eq(user.id))).order('id ASC')
  }

  def cor(user)
    if user.id == passenger_id
      driver
    else
      passenger
    end
  end

end
