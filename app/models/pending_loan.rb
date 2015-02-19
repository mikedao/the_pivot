class PendingLoan
  def initialize(pending_loan)
    @pending_loan = pending_loan
  end

  def projects
    projects_and_loan_amounts = {}
    @pending_loan.each do |project_id, loan_amount|
      projects_and_loan_amounts[Project.find(project_id)] = loan_amount.to_i
    end
    projects_and_loan_amounts
  end

  def calculate_total_cost
    projects.values.reduce(:+)
  end

  def present?
    !@pending_loan.empty?
  end

  def checkout!(user_id)
    order = Order.create(
      user_id: user_id.to_i,
      total_cost: calculate_total_cost,
      status: "ordered"
    )
    projects.keys.each do |project|
      Loan.create(
        project_id: project.id,
        order_id: order.id
      )
    end
    order
  end
end
