class Item < ActiveRecord::Base
  validates :name, presence: true
  has_many :items_categories
  has_many :categories, through: :items_categories
end
