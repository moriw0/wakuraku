class HostedDate < ApplicationRecord
  belongs_to :event

  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :srart_at_should_be_before_end_at

  private

  def srart_at_should_be_before_end_at
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, 'は終了時間よりも前に設定してください')
    end
  end
end
