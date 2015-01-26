class Order < ActiveRecord::Base
  belongs_to :user

  has_many :item_orders
  has_many :items, through: :item_orders

  validates :total_cost, :user_id, presence: true

  def self.complete
    all.select { |order| order.status == 'completed'}
  end

  def self.paid
    all.select { |order| order.status == 'paid'}
  end

  def self.cancelled
    all.select { |order| order.status == 'cancelled'}
  end

  def self.ordered
    all.select { |order| order.status == 'ordered'}
  end

end
