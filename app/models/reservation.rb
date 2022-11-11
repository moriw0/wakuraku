class Reservation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event
  belongs_to :hosted_date

  validates :comment, length: { maximum: 200 }, allow_blank: true
  with_options presence: true do
    validates :user_id
    validates :event_id
    validates :hosted_date_id, uniqueness: true 
  end
end
