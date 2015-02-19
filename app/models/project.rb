class Project < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  scope :active, -> { where(retired: false) }

  has_many :projects_categories
  has_many :categories, through: :projects_categories
  has_many :photos
  has_many :loans
  has_many :orders, through: :loans
  belongs_to :tenant

  validates :description, length: { in: 100..255, allow_nil: false },
                          presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true,
                    numericality:
                    {
                      only_integer: true,
                      greater_than: 999,
                      less_than: 100000
                    }
  validates :categories, presence: true

  before_create :add_default_photo

  def formatted_dollar_amount
    number_to_currency(price / 100.00)
  end

  private

  def add_default_photo
    default_photo = Photo.create(image_file_name: "johns_waterworks",
                                 image_content_type: "jpg",
                                 image_file_size: 300)
    self.photos = [default_photo] unless photos.count > 0
  end
end
