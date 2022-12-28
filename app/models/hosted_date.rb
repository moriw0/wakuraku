class HostedDate < ApplicationRecord
  belongs_to :event
  has_many :reservations, dependent: :restrict_with_exception

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :started_at_should_be_after_now
  validate :srart_at_should_be_before_ended_at
  validate :hosted_date_should_not_be_overlapping

  def self.of_created_events_by(user)
    joins(:event).where(events: { owner_id: user, is_published: true })
  end

  def self.of_participating_events_by(user)
    joins(reservations: :event).where(reservations: { user_id: user, is_canceled: false })
  end

  def available?
    true unless capacity_left.zero?
  end

  def capacity_left
    event.capacity - reservations.reserved.count
  end

  def reserved_by?(user)
    reservations.exists?(user: user, is_canceled: false)
  end

  private

  def started_at_should_be_after_now
    errors.add(:started_at, 'は現在時刻より後に設定してください') if started_at <= DateTime.now
  end

  def srart_at_should_be_before_ended_at
    return unless started_at && ended_at

    errors.add(:started_at, 'は終了時間よりも前に設定してください') if started_at >= ended_at
  end

  def hosted_date_should_not_be_overlapping
    return unless started_at && ended_at

    if HostedDate.where(event_id: event.id)
                 .where('started_at < ?', ended_at)
                 .where('ended_at > ?', started_at)
                 .where.not(id: id).exists?

      errors.add(:base, 'が既に存在する期間と重複しています。')
    end
  end
end
