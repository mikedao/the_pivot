class Category < ActiveRecord::Base
<<<<<<< HEAD
  has_many :items_categories
  has_many :items, through: :items_categories

  validates :name, uniqueness: { :case_sensitive => false }, presence: true
end
