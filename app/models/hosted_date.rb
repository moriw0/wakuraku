class HostedDate < ApplicationRecord
  belongs_to :event
  has_many :reservations

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :event_id, uniqueness: { scope: [:started_at, :ended_at], message: '内に既に存在する開催日時です。' }
  validate :started_at_should_be_after_now
  validate :srart_at_should_be_before_ended_at
  validate :hosted_date_should_not_be_overlapping

  def available?
    true unless capacity_left.zero?
  end

  def capacity_left
    self.event.capacity - self.reservations.reserved.count
  end

  private

  def started_at_should_be_after_now
    if started_at <= DateTime.now
      errors.add(:started_at, 'は現在時刻より後に設定してください')
    end
  end

  def srart_at_should_be_before_ended_at
    return unless started_at && ended_at

    if started_at >= ended_at
      errors.add(:started_at, 'は終了時間よりも前に設定してください')
    end
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
