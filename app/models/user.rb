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

  before_save :ensure_authentication_token
  # after_create :send_welcome_mail

  def self.from_omniauth(auth, email)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = email
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
    attributes['image_url'].sub(/^http:\/\//,'https://')
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
end
