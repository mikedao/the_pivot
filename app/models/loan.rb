class Loan < ActiveRecord::Base
  belongs_to :project
  belongs_to :order
  validates :order_id, presence: true
  validates :project_id, presence: true
  validates :project, presence: true
  validates :amount, presence: true, numericality: { :less_than_or_equal_to => :project_amount}

  private

  def project_amount
    self.project.price
  end
end
