class Tenant < ActiveRecord::Base
  has_many :items
  has_many :user
end
