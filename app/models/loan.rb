class Loan < ActiveRecord::Base
  belongs_to :project
  belongs_to :order
  validates :order_id, presence: true
  validates :project_id, presence: true
  validates :amount, presence: true, numericality:
    {
      greater_than_or_equal_to: 1000,
      less_than_or_equal_to: :project_amount_needed
    }

  private

  def project_amount_needed
    if project.nil?
      1000
    else
      project.amount_needed
    end
  end
end
