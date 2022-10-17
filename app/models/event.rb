class Event < ApplicationRecord
  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :title, length: { maximum: 100 }, presence: true
  validates :discription, length: { maximum: 2000 }, presence: true
  validates :price, length: { maximum: 7 }, presence: true
  validates :required_time, length: { maximum: 3 }, presence: true
  validates :capacitiy, length: { maximum: 3 }, presence: true
  validates :is_published, inclusion: {in: [true, false]}
end
