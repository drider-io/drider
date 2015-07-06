class Message < ActiveRecord::Base
  belongs_to :from, class: 'User'
  belongs_to :to, class: 'User'
  belongs_to :car_request

end
