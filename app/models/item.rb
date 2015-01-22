class Item < ActiveRecord::Base
  validates :title, presence: true
  has_many :items_categories
  has_many :categories, through: :items_categories

  def quantity
    
  end
end
