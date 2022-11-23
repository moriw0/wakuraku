class HostedDate < ApplicationRecord
  belongs_to :event
  has_many :reservations

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :srart_at_should_be_before_ended_at
  
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
end
