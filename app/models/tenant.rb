class Tenant < ActiveRecord::Base
  has_many :projects
  has_many :categories, through: :projects
  has_many :user

  before_save :create_slug

  validates :location,     presence: true, length: { in: 6..255 }
  validates :organization, presence: true, length: { in: 4..255 }

  def create_slug
    self.slug = organization.parameterize
  end
end
