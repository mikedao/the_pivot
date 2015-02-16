class Loan < ActiveRecord::Base
  belongs_to :project
  belongs_to :order
  validates :order_id, presence: true
  validates :project_id, presence: true
end
