class Reservation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event
  belongs_to :hosted_date

  validates :comment, length: { maximum: 200 }, allow_blank: true
  with_options presence: true do
    validates :event_id
    validates :hosted_date_id, uniqueness: { scope: %i[user_id event_id] }
  end

  scope :with_associations, -> { preload(:hosted_date, :event) }
  scope :reserved, -> { where(is_canceled: false) }
  scope :canceled, -> { where(is_canceled: true) }
  scope :sorted, -> { order(updated_at: :desc) }
  scope :with_recent_associations, -> { with_associations.reserved.sorted }
  scope :recent_canceled, -> { with_associations.canceled.sorted }
end
