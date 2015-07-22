class CarRequest < ActiveRecord::Base
  enum status: {
      sent: 'sent',
      accepted: 'accepted',
      confirmed: 'confirmed',
      ride: 'ride',
      finished: 'finished',
      canceled: 'canceled',
    }
  enum delivery_status: {
      posted: 'posted',
      delivered: 'delivered',
      read: 'read',
    }


  belongs_to :driver, class_name: 'User'
  belongs_to :passenger, class_name: 'User'
  belongs_to :active_user, class_name: 'User'
  has_many :messages
  belongs_to :car_route

  after_save do
    ActiveSupport::Notifications.instrument('car_request_changed', request: self)
  end

  scope :with_user, ->(user) {
    r = arel_table
    where(r[:driver_id].eq(user.id).or(r[:passenger_id].eq(user.id)))
  }

  scope :unread, ->(user) {
    where(delivery_status: ['posted','delivered'], active_user: user)
  }

  def cor(user)
    if user.id == passenger_id
      driver
    else
      passenger
    end

  end

  def is_driver?(user)
    user.id == driver_id
  end

  def is_passenger?(user)
    user.id == passenger_id
  end

  include AASM
  aasm :column => 'status', :enum => true do
    state :sent, :initial => true
    state :accepted
    state :confirmed
    state :ride
    state :finished
    state :canceled

    event :accept, after: :update_delivery do
      transitions :from => :sent, :to => :accepted, :guard=>:is_driver?
    end

    event :confirm, after: :update_delivery do
      transitions :from => :accepted, :to => :confirmed, :guard=>:is_passenger?
    end

    event :ride, after: :update_delivery do
      transitions :from => :confirmed, :to => :ride
    end

    event :finish, after: :update_delivery do
      transitions :from => [:ride, :confirmed], :to => :finished
    end

    event :cancel, after: :update_delivery do
      transitions :from => [:sent, :accepted, :confirmed], :to => :canceled
    end

  end

  def update_delivery(n, user)
    self.active_user = cor(user)
    self.delivery_status='posted'
  end


end
