class CarSearch < ActiveRecord::Base
  include AASM
  belongs_to :user
  validates :from, presence: true

  aasm :column => 'state' do
    state :new, :initial => true
    state :active
    state :closed

    event :perform do
      transitions from: :new, to: :active, after: -> (passenger) do
        CarRouteSearcher.new.drivers(self.last_search).limit(10).each { |driver|
          CarRequest.create(
            car_search: self,
            driver: driver,
            passenger: passenger,
            status: :sent
          )
          DriverNotifier.new(driver).perform
        }

      end
    end
  end

  # after_initialize do |car_search|
  #   car_search.from_m = GeoLocation.new(address: car_search.from_title).m unless car_search.from_m || !car_search.from_title.present?
  #   car_search.to_m = GeoLocation.new(address: car_search.to_title).m unless car_search.to_m || !car_search.to_title.present?
  #   car_search.from_title = GeoLocation.new(location: car_search.from_m).address if car_search.from_title.blank? && car_search.from_m
  #   car_search.to_title = GeoLocation.new(location: car_search.to_m).address if car_search.to_title.blank? && car_search.to_m
  # end
  #
  # def from_g
  #   GeoLocation.new.to_g(from_m) if from_m
  # end
  #
  # def from_g=(value)
  #   lat, lng = value.split(/\s*,\s*/)
  #   self.from_m = GeoLocation.new.to_m(lat, lng)
  # end
  #
  # def to_g=(value)
  #   lat, lng = value.split(/\s*,\s*/)
  #   self.to_m = GeoLocation.new.to_m(lat, lng)
  # end
  #
  # def to_g
  #   GeoLocation.new.to_g(to_m) if to_m
  # end
  scope :with_user, ->(user) {
    where(user: user)
  }

  def from
    from_title
  end

  def to
    to_title
  end
end
