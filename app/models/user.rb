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

  def self.from_omniauth(auth, email)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image_url = auth.info.image # assuming the user model has an image
    end
  end

  def first_name
    name.try(:match, /^(\w+)/).try(:[], 1)
  end


  def is_admin?
    %w(10204815960659631 885617441511540).include? uid
  end
end
