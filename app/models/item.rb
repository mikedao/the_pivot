class Item < ActiveRecord::Base

  scope :active, -> {where(retired:false)}
  has_attached_file :image, :default_url => "default.jpg"
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png']

  has_many :items_categories
  has_many :categories, through: :items_categories

  has_many :item_orders
  has_many :orders, through: :item_orders

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }
end
