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
#TODO validators

  belongs_to :driver, class_name: 'User'
  belongs_to :passenger, class_name: 'User'
  belongs_to :active_user, class_name: 'User'
  has_many :messages
  belongs_to :car_route
  belongs_to :car_search

  delegate :from_title, to: :car_search
  delegate :to_title, to: :car_search
  delegate :from_m, to: :car_search
  delegate :to_m, to: :car_search

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
    elsif user.id == driver_id
      passenger
    else
      raise ActiveRecord::RecordInvalid.new "unknown user_id #{user.id} for car_request id:#{id}"
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

    event :accept, after_commit: :notify_rider do
      transitions :from => :sent, :to => :accepted
    end

    event :confirm do
      transitions :from => :accepted, :to => :confirmed, :guard=>:is_passenger?
    end

    event :ride do
      transitions :from => :confirmed, :to => :ride
    end

    event :finish do
      transitions :from => [:ride, :confirmed], :to => :finished
    end

    event :cancel do
      transitions :from => [:sent, :accepted, :confirmed, :canceled], :to => :canceled
    end

    event :decline, after_commit: :notify_rider do
      transitions :from => [:sent], :to => :canceled
    end

  end

  def update_delivery(n, user)
    # self.active_user = cor(user)
    # self.delivery_status='posted'
  end

  def just_created?
    created_at == updated_at
  end

  def notify_rider
    RiderNotifier.new(car_search).perform
  end
end
