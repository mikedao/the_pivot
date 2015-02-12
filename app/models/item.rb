class Item < ActiveRecord::Base

  scope :active, -> {where(retired:false)}

  has_many :items_categories
  has_many :categories, through: :items_categories

  has_many :item_orders
  has_many :orders, through: :item_orders
  belongs_to :tenant

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }
end
