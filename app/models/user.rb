class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  ## realtions
  has_many :surveys

  ## scopes
  scope :latest_surveys, -> { surveys.order(created: :desc )}


  def login=(login)
    @login = login
  end

  def login
    @login || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:email)
      where(conditions.to_h).where(["lower(email) = :value", { value:  login.downcase }]).first
    elsif conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def user_to_json
    {
      email: email,
      auth_token: auth_token
    }
  end
end
