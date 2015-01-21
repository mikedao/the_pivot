class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :item_orders
  has_many   :items, through: :item_orders

  validates :total_cost, :user_id, presence: true
end
