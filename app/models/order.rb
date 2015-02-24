class Order < ActiveRecord::Base
  belongs_to :user

  has_many :loans, after_add: :calculate_new_order_total
  has_many :projects, through: :loans
  validates :user_id, presence: true
  after_save :calculate_order_total

  def self.complete
    all.select { |order| order.status == "completed" }
  end

  def self.paid
    all.select { |order| order.status == "paid" }
  end

  def self.cancelled
    all.select { |order| order.status == "cancelled" }
  end

  def self.ordered
    all.select { |order| order.status == "ordered" }
  end

  def final_total
    if loans.present?
      self.total_cost = loans.map(&:amount).reduce(:+)
    else
      self.total_cost = 0
    end
  end

  private

  def calculate_new_order_total(_loan)
    calculate_order_total
  end

  def calculate_order_total
    if loans.present?
      self.total_cost = loans.map(&:amount).reduce(:+)
    else
      self.total_cost = 0
    end
  end
end
