class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable,:registerable,
  devise :database_authenticatable,
         :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:facebook]
  has_many :car_sessions, dependent: :destroy
  has_many :car_routes, dependent: :destroy
  has_many :car_locations
  has_many :devices, dependent: :destroy
  has_many :car_searches, dependent: :destroy
  belongs_to :last_search, class_name: 'CarSearch'
  belongs_to :parent, class_name: 'User'

  before_save :ensure_authentication_token
  after_create :send_welcome_mail, if: Proc.new { self.email.present? }

  scope :fb_chat_authed, -> { where('fb_chat_id IS NOT NULL') }

  validates :phone, phone: true, unless: Proc.new {|u| u.phone.nil? }

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

  def link_to(parent:)
    update!(parent: parent)
    Redis.new.publish "user_#{id}", "disconnect"
    transaction do
      CarLocation.unscoped.where(user: self).update_all(user_id: parent.id)
      CarSession.unscoped.where(user: self).update_all(user_id: parent.id)
      CarRoute.unscoped.where(user: self).update_all(user_id: parent.id)
      CarRoute.unscoped.where(user: self).update_all(user_id: parent.id)
      Device.unscoped.where(user: self).update_all(user_id: parent.id)
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

  def image_url191
    "http://drider.io.rsz.io/profile_picture/#{id}?width=382&height=200&bgcolor=fff"
  end

  def linked_to_fb?
    fb_chat_id.present? || (parent.present? && parent.fb_chat_id.present?)
  end

  def identified?
    uid.present?
  end

  def self.all_states
    aasm.states.map(&:name)
  end

  include AASM
  aasm :column => 'bot_state', :whiny_transitions => true do
    state :role_select, :initial => true
    state :new
    state :p_from
    state :p_to
    state :p_time
    state :p_search
    state :p_history
    state :d_role

    after_all_transitions :send_message

    event :new_search do
      transitions from: :p_search, to: :p_search, after: :search_in_progress
      transitions from: User.all_states, to: :p_from,
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
          car_search = CarSearch.create!(from_m: m, from_title: address, user: self)
          self.last_search = car_search
          car_search.has_results = true
          passenger_action.ok
          passenger_action.provide_to
        end

      transitions from: :p_from, to: :p_from,
        after: -> do
          passenger_action.provide_another_from
        end

      transitions from: :p_to, to: :p_from,
                  guard: -> (coordinates) do
                    self.last_search.blank?
                  end,
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

    event :select_rider do
      before do
        self.driver_role = false
        save!
        passenger_action.how_can_help_you
      end
      transitions from: User.all_states, to: :new
    end

    event :select_driver do
      before do
        self.driver_role = true
        save!
      end
      transitions from: User.all_states, to: :d_role, after: -> do

      end
    end

    event :text do
      transitions from: :role_select, to: :role_select, after: -> do
        Action::Generic.new(fb_chat_id).please_select_role
      end
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
      transitions from: :d_role, to: :d_role
    end

    event :finish_search do
      transitions from: :p_search, to: :new
    end
end
  def model
    self
  end

  def send_message
    if driver_role?
      driver_message
    end
  end

  def driver_message
    if ever_drive?
      driver_action.please_keep_recording
    else
      driver_action.please_record_a_route
    end
  end

  private

  def driver_action
    Action::Driver.new(fb_chat_id)
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def welcome!(*args)
    Action::Generic.new(fb_chat_id).please_select_role
  end

  def send_welcome_mail
    UserMailer.welcome(id).deliver_later
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
    if phone.present?
      req = CarRequest.where(driver: self, id: options['req']).first
      req.accept!
      passenger_action.driver_accepted_request(req.passenger.name)
    else
      button = {
         type: 'web_url',
         title: 'Вказати телефон',
         url: Rails.application.routes.url_helpers.new_account_phone_url + "?auth_token=#{authentication_token}",
         webview_height_ratio: "compact",
         webview_share_button: "HIDE"
      }
      button[:messenger_extensions] = true if Rails.application.routes.url_helpers.root_url.start_with?('https://')
      FbMessage.new(fb_chat_id)
        .button_template(text: 'Чудово, будь-ласка вкажіть телефон за яким з вами можна домовитись щодо поіздки',
                         buttons: [ button ])
        .deliver
    end
  end

  def d_decline!(nothing, options)
    CarRequest.where(driver: self, id: options['req']).first.try('decline!')
  end
end
