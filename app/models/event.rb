class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_one_attached :image, dependent: false
  has_many :hosted_dates, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_exception
  accepts_nested_attributes_for :hosted_dates, allow_destroy: true

  attr_accessor :remove_image

  before_save :remove_image_if_user_accept

  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :title, length: { maximum: 100 }, presence: true
  validates :discription, length: { maximum: 2000 }, presence: true
  validates :price, length: { maximum: 7 }, presence: true
  validates :required_time, length: { maximum: 3 }, presence: true
  validates :capacity, length: { maximum: 3 }, presence: true
  validates :is_published, inclusion: { in: [true, false] }
  validates :image, content_type: { in: %i[png jpg jpeg],
                                    message: :invalid_content_type },
                    size: { less_than_or_equal_to: 5.megabytes,
                            message: :invalid_size },
                    dimension: { width: { max: 3840 }, height: { max: 2160 },
                                 message: :invalid_dimention }

  scope :with_dates, -> { eager_load(:hosted_dates) }
  scope :published, -> { where(is_published: true) }
  scope :sorted, -> { order(updated_at: :desc) }
  scope :with_recent_dates, -> { with_dates.published.sorted }
  scope :recent, -> { published.sorted }

  def created_by?(user)
    return false unless user

    owner.id == user.id
  end

  private

  def remove_image_if_user_accept
    self.image = nil if ActiveRecord::Type::Boolean.new.cast(remove_image)
  end
end
