class User < ApplicationRecord
  before_destroy :check_all_events_finished

  has_many :created_events, class_name: 'Event', foreign_key: 'owner_id', dependent: :nullify
  has_many :reservations, dependent: :nullify

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :profile, length: { maximum: 200 }

  def created_event_reservations
    Reservation.joins(:event).where(event: { owner_id: self })
  end

  def customers
    User.joins(reservations: :event).where(events: { owner_id: self }).distinct
  end

  def created_event_hosted_dates
    HostedDate.joins(:event).where(events: { owner_id: self })
  end

  def participating_event_hosted_dates
    HostedDate.joins(event: :reservations).where(reservations: { user_id: self })
  end
  
  def reservations_by(customer)
    created_event_reservations.where(user_id: customer)
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

  private

  def check_all_events_finished
    now = Time.zone.now
    if created_event_hosted_dates.where(':now < ended_at', now: now).exists?
      errors.add(:base, '公開中の未終了イベントが存在します')
    end

    if participating_event_hosted_dates.where(':now < ended_at', now: now).exists?
      errors.add(:base, '未終了の参加イベントが存在します')
    end

    throw :abort unless errors.empty?
  end
end
