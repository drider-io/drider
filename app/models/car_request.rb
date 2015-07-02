class CarRequest < ActiveRecord::Base
  enum status: [:sent, :accepted, :confirmed, :ride, :finished, :canceled]

  belongs_to :driver, class: 'User'
  belongs_to :passenger, class: 'User'
end
