class Tenant < ActiveRecord::Base
  belongs_to :user
end
