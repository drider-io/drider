class CarRequest < ActiveRecord::Base
  enum status: {
      sent: 'sent',
      accepted: 'accepted',
      confirmed: 'confirmed',
      ride: 'ride',
      finished: 'finished',
      canceled: 'canceled',
    }


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

  def can_close?(*aaa)
    p aaa
    true
  end

  include AASM
  aasm :column => 'status', :enum => true do
    state :sent, :initial => true

    event :run do
      transitions :from => :sent, :to => :accepted, :guard=>:can_close?
    end

    event :cancel


  end


end
