class Tenant < ActiveRecord::Base
  has_many :projects
  has_many :categories, through: :projects
  has_many :user

  before_save :create_slug

  validates :location,     presence: true
  validates :organization, presence: true

  def create_slug
    self.slug = organization.parameterize
  end
end
