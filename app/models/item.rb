class Item < ActiveRecord::Base
  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }

  has_many :items_categories
  has_many :categories, through: :items_categories

  has_many :item_orders
  has_many :orders, through: :item_orders

  def quantity

  end
end
