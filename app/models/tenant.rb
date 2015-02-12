class Tenant < ActiveRecord::Base
  has_many :items
end
