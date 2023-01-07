class Event < ApplicationRecord
  searchkick language: 'japanese'

  belongs_to :owner, class_name: 'User'
  has_many_attached :images, dependent: false
  has_many :hosted_dates, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_exception
  accepts_nested_attributes_for :hosted_dates, allow_destroy: true

  attr_accessor :image_ids

  before_save :remove_selected_images

  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :title, length: { maximum: 100 }, presence: true
  validates :discription, length: { maximum: 2000 }, presence: true
  validates :price, length: { maximum: 7 }, presence: true
  validates :required_time, length: { maximum: 3 }, presence: true
  validates :capacity, length: { maximum: 3 }, presence: true
  validates :is_published, inclusion: { in: [true, false] }
  validates :images, content_type: { in: %i[png jpg jpeg],
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

  def search_data
    {
      name: name,
      place: place,
      title: title,
      discription: discription,
      owner_name: owner&.name
    }
  end

  private

  def remove_selected_images
    return unless image_ids

    image_ids.each do |image_id|
      image = images.find(image_id)
      image.purge
    end
  end
end
