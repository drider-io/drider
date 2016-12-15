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

    event :new_search, after: :notify_users do
      after do |transition, message|
        FbMessage.new(fb_chat_id).quick_replies(text: 'Звідки: вкажіть координату', replies: :location).deliver
      end
      transitions :to => :p_from
    end

    event :p_from_entered, after: :notify_users do
      after do |transition, message|
        FbMessage.new(fb_chat_id).quick_replies(text: 'Куди: вкажіть координату', replies: :location).deliver
      end

      transitions :from => :p_from, :to => :p_to
    end

    event :p_to_entered, after: :notify_users do
      transitions :from => :p_to, :to => :p_time
    end

    event :go_now, after: :notify_users do
      after do |transition, message|
        CarRouteSearcher.new.drivers(last_search).limit(10).each do |driver|
          CarRequest.create(
            car_search: last_search,
            driver: driver,
            passenger: self,
            status: :sent
          # pickup_location: last_search.from_m,
          # pickup_address: last_search.from_title,
          # drop_location: last_search.to_m,
          # drop_address: last_search.to_title
          )
          DriverNotifier.new(driver).perform
        end
      end
      transitions :from => :p_time, :to => :p_search
    end
  end
  
  def notify_users
    
  end
end
