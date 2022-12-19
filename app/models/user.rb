class User < ApplicationRecord
  include Discard::Model

  has_many :created_events, class_name: 'Event', foreign_key: 'owner_id'
  has_many :reservations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :profile, length: { maximum: 200 }

  def created_event_reservations
    Reservation.joins(:event).where(event: { owner_id: self })
  end

  def customers
    User.kept.joins(reservations: :event).where(events: { owner_id: self }).distinct
  end

  def reservations_by(customer)
    created_event_reservations.where(user_id: customer)
  end

  def mask_and_discard
    return false unless check_all_events_finished

    ActiveRecord::Base.transaction do
      mask_personal_data!
      discard!
    end
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

    errors.empty?
  end

  def created_event_hosted_dates
    HostedDate.joins(:event).where(events: { owner_id: self, is_published: true })
  end

  def participating_event_hosted_dates
    HostedDate.joins(reservations: :event).where(reservations: { user_id: self, is_canceled: false })
  end

  def mask_personal_data!
    update!(
      email: "#{SecureRandom.urlsafe_base64}@example.com",
      phone_number: nil,
      uid: nil,
      name: nil,
      image: nil,
    )
  end
end
