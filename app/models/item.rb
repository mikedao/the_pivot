class Item < ActiveRecord::Base
  # has_attached_file :photo, :default_url => "/images/:style/default.jpg"
  scope :active, -> {where(retired:false)}

  has_many :items_categories
  has_many :categories, through: :items_categories

  has_many :item_orders
  has_many :orders, through: :item_orders

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }
  # validates :photo, allow_blank: true
  # after_validation :categories

  # def has_categories
  #   errors.add(:category, "needs a category") if self.categories.empty?
  # end
end
