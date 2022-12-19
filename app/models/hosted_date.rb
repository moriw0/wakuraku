class HostedDate < ApplicationRecord
  belongs_to :event
  has_many :reservations

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :event_id, uniqueness: { scope: [:started_at, :ended_at] }
  validate :srart_at_should_be_before_ended_at
  validate :hosted_date_should_not_be_overlapping, if: :new_or_start_or_end_time_changed
  
  def available?
    true unless capacity_left.zero?
  end

  def capacity_left
    self.event.capacity - self.reservations.reserved.count
  end
  
  private

  def srart_at_should_be_before_ended_at
    return unless started_at && ended_at

    if started_at >= ended_at
      errors.add(:started_at, 'は終了時間よりも前に設定してください')
    end
  end

  def new_or_start_or_end_time_changed
    new_record? || will_save_change_to_start_time? || will_save_change_to_end_time?
  end

  def hosted_date_should_not_be_overlapping
    return unless started_at && ended_at

    if HostedDate.where(event_id: event.id)
      .where('started_at < ?', ended_at)
      .where('ended_at > ?', started_at)
      .where.not(id: id).exists?

      errors.add(:base, '他の開催日時と重複しています。')
    end
  end 
end
