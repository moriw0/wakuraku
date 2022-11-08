class Reservation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  validates :comment, length: { maximum: 200 }, allow_blank: true
end
