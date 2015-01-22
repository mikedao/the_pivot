class Order < ActiveRecord::Base
  belongs_to :user
  
  has_many :item_orders
  has_many :items, through: :item_orders

  validates :total_cost, :user_id, presence: true
end
