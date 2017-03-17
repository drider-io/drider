class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable,:registerable,
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  has_many :car_sessions
  has_many :car_routes
  has_many :devices
  has_many :car_searches
  belongs_to :last_search, class_name: 'CarSearch'

  before_save :ensure_authentication_token
  after_create :send_welcome_mail

  scope :fb_chat_authed, -> { where('fb_chat_id IS NOT NULL') }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image_url = auth.info.image # assuming the user model has an image
    end
  end

  def self.from_auth(email:, provider:, uid:, name:, image_url:)
    where(provider: provider, uid: uid).first_or_create do |user|
      user.email = email
      user.password = Devise.friendly_token[0,20]
      user.name = name   # assuming the user model has a name
      user.image_url = image_url # assuming the user model has an image
    end
  end

  def first_name
    name.try(:match, /^(\w+)/).try(:[], 1)
  end


  def is_admin?
    %w(10204815960659631 885617441511540).include? uid
  end

  def driver_role?
    driver_role
  end

  def role_defined?
    !driver_role.nil?
  end

  def ever_drive?
    ever_drive
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def image_url
    "https://graph.facebook.com/#{uid}/picture?type=square"
  end

  def image_url191
    "http://drider.io.rsz.io/profile_picture/#{uid}?width=382&height=200&bgcolor=fff"
  end

  def identified?
    uid.present?
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def send_welcome_mail
      UserMailer.welcome(id).deliver_later
  end


  include AASM
  aasm :column => 'bot_state' do
    state :new, :initial => true
    state :p_from
    state :p_to
    state :p_time
    state :p_search
    state :p_history

    # event :d_accept do
    #
    # end

    event :new_search do
      transitions from: :p_search, to: :p_search, after: :search_in_progress
      transitions from: :new, to: :p_from,
        after: -> do
          passenger_action.provide_from
        end
    end

    event :p_cancel do
      transitions to: :new,
        after: -> do
          passenger_action.canceled
        end
    end

    # event :go_now do
    #   transitions to: :p_search,
    #     after: -> do
    #
    #     end
    # end

    event :go_now do
      transitions :from => :p_time, :to => :p_search,
                  after: -> do
                    passenger_action.please_wait
                    self.last_search.perform!(nil, self)
                    RiderNotifier.new(self.last_search).perform
                  end
    end


    event :location do
      transitions from: :p_from, to: :p_to,
        guard: -> (coordinates) do
          m = GeoLocation.new.to_m(coordinates['lat'].to_s, coordinates['long'].to_s)
          CarRouteSearcher.new.pass_by(m).present?
        end,
        after: -> (coordinates) do
          m = GeoLocation.new.to_m(coordinates['lat'].to_s, coordinates['long'].to_s)
          address = GeoLocation.new(location: m).address
          car_search = CarSearch.new(from_m: m, from_title: address, user: self)
          self.last_search = car_search
          car_search.has_results = true
          passenger_action.ok
          passenger_action.provide_to
        end

      transitions from: :p_from, to: :p_from,
        after: -> do
          passenger_action.provide_another_from
        end

      transitions from: :p_to, to: :p_time,
        guard: -> (coordinates) do
          m = GeoLocation.new.to_m(coordinates['lat'].to_s, coordinates['long'].to_s)
          address = GeoLocation.new(location: m).address
          car_search = self.last_search
          if car_search.to_m.present?
            car_search = self.last_search = car_search.dup
          end

          car_search.to_m = m
          car_search.to_title = address
          car_search.save!
          @drivers_count = CarRouteSearcher.new.drivers_count(car_search)
          @drivers_count > 0
        end,
        after: -> do
          self.last_search.has_results=true
          passenger_action.drivers_found(@drivers_count)
        end

      transitions from: :p_to, to: :p_to, after: -> do
        self.last_search.has_results = false
        passenger_action.provide_another_to
      end
    end

    event :text do
      transitions from: :p_search, to: :p_search, after: :search_in_progress
      transitions from: :p_time, to: :p_time, after: :p_time_in_progress
      transitions from: :p_from, to: :p_from, after: -> do
        passenger_action.location_only
      end
      transitions from: :p_to, to: :p_to, after: -> do
        passenger_action.location_only
      end
      transitions from: :new, to: :new, after: -> do
        passenger_action.how_can_help_you
      end
    end
end
  def model
    self
  end

  def passenger_action
    Action::Passenger.new(fb_chat_id)
  end

  def p_time_in_progress
    drivers_count = CarRouteSearcher.new.drivers_count(last_search)
    passenger_action.drivers_found(drivers_count)
  end

  def search_in_progress
    passenger_action.search_in_progress
  end

  def d_accept!(nothing, options)
    req = CarRequest.where(driver: self, id: options['req']).first
    req.accept!
    passenger_action.driver_accepted_request(req.passenger.name)
  end

  def d_decline!(nothing, options)
    CarRequest.where(driver: self, id: options['req']).first.try('decline!')
  end
end
