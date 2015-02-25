class Tenant < ActiveRecord::Base
  has_many :projects
  has_many :categories, through: :projects
  has_many :users

  before_save :create_slug

  validates :location,     presence: true, length: { in: 6..255 }
  validates :organization, presence: true, length: { in: 4..255 }

  def create_slug
    self.slug = organization.parameterize
  end

  def self.unapproved
    Tenant.where(approved: false)
  end

  def self.inactive
    Tenant.where(active: false)
  end

  def self.actives
    Tenant.where(active: true)
  end

  def visible_to_lenders
    active && approved
  end
end
