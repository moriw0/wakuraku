class User < ApplicationRecord
  include Discard::Model

  has_many :created_events, class_name: 'Event', foreign_key: 'owner_id', dependent: :restrict_with_exception,
                            inverse_of: 'owner'
  has_many :reservations, dependent: :restrict_with_exception
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :profile, length: { maximum: 200 }

  def self.customers_of(user)
    kept.joins(reservations: :event).where(events: { owner_id: user }).distinct
  end

  def reservations_by(customer)
    Reservation.of_created_events_by(self).where(user_id: customer)
  end

  def retire_process_and_discard
    return false unless check_all_events_finished

    ActiveRecord::Base.transaction do
      hide_created_events!
      mask_personal_data!
      discard!
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      avatar_url = URI.parse(auth.info.image.to_s).open
      user.avatar.attach(io: avatar_url, filename: 'user_avatar.jpg')
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def check_all_events_finished
    now = Time.zone.now
    if HostedDate.of_created_events_by(self).exists?([':now < ended_at', { now: now }])
      errors.add(:base, '公開中の未終了イベントが存在します')
    end

    if HostedDate.of_participating_events_by(self).exists?([':now < ended_at', { now: now }])
      errors.add(:base, '未終了の参加イベントが存在します')
    end

    errors.empty?
  end

  def hide_created_events!
    created_events.each { |event| event.update!(is_published: false) }
  end

  def mask_personal_data!
    dummy_url = "#{SecureRandom.urlsafe_base64}@example.com"
    dummy_id = "discarded_#{id}"

    update!(
      email: dummy_url,
      image: dummy_url,
      uid: dummy_id,
      name: dummy_id,
      phone_number: '000-0000-0000'
    )
  end
end
