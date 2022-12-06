class User < ApplicationRecord
  has_many :created_events, class_name: 'Event', foreign_key: 'owner_id'
  has_many :reservations
  has_many :created_event_reservations, through: :created_events, source: :reservations
  has_many :customers, -> { distinct }, through: :created_event_reservations, source: :user

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :profile, length: { maximum: 200 }

  def reservations_by_customer(id)
    created_event_reservations.where(user_id: id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   
      user.image = auth.info.image 
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
