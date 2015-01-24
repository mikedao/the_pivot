class Item < ActiveRecord::Base
  has_many :items_categories
  has_many :categories, through: :items_categories
<<<<<<< HEAD
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }
  # validates :photo, allow_blank: true
  # after_validation :categories

=======
>>>>>>> b9d6c8b2e76dac9019df2298ae2506591641d228


  def

  validates :description, length: { in: 0..255, allow_nil: false }, presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true, :numericality => { :only_integer => true }

  def quantity

  end

  # def has_categories
  #   errors.add(:category, "needs a category") if self.categories.empty?
  # end
end
