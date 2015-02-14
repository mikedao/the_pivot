class Item < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  scope :active, -> {where(retired:false)}

  has_many :items_categories
  has_many :categories, through: :items_categories
  has_many :photos
  has_many :item_orders
  has_many :orders, through: :item_orders
  belongs_to :tenant

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true,
                    numericality:
                    {
                      only_integer: true,
                      greater_than: 0,
                      less_than: 100000
                    }
  validates :categories, presence: true

  before_save :add_default_photo

  def formatted_dollar_amount
    number_to_currency(price / 100.00)
  end

  private

  def add_default_photo
    default_photo = Photo.create
    self.photos = [default_photo] unless photos.count > 0
  end
end
