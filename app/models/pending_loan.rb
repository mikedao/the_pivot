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

  def present?
    @pending_loan.present?
  end

  def pending_total
    @pending_loan.values.inject(0) do |sum, loan_amount|
      sum + loan_amount.to_i
    end
  end

  def checkout!(user_id)
    order = Order.create(
      user_id: user_id.to_i,
      status: "ordered"
    )
    projects.keys.each do |project|
      Loan.create(
        amount: 2500,
        project_id: project.id,
        order_id: order.id
      )
    end
    order
  end
end
