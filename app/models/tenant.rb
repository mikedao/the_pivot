class Tenant < ActiveRecord::Base
  has_many :user
end
