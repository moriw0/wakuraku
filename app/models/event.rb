class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :hosted_dates, dependent: :destroy
  has_many :reservations
  accepts_nested_attributes_for :hosted_dates, allow_destroy: true

  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :title, length: { maximum: 100 }, presence: true
  validates :discription, length: { maximum: 2000 }, presence: true
  validates :price, length: { maximum: 7 }, presence: true
  validates :required_time, length: { maximum: 3 }, presence: true
  validates :capacity, length: { maximum: 3 }, presence: true
  validates :is_published, inclusion: {in: [true, false]}

  scope :with_dates, -> { eager_load(:hosted_dates) }
  scope :published, -> { joins(:owner).merge(User.kept).where(is_published: true) }
  scope :sorted, -> { order(updated_at: :desc) }
  scope :with_recent_dates, -> { with_dates.published.sorted }
  scope :recent, -> { published.sorted }

  def created_by?(user)
    return false unless user

    owner.id == user.id
  end
end
