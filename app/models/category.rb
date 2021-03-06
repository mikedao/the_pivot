class Category < ActiveRecord::Base
  has_many :projects_categories
  has_many :projects, through: :projects_categories
  has_many :photos

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
