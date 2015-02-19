class PendingLoan
  def initialize(pending_loan)
    @pending_loan = pending_loan
  end

  def projects
    output = {}
    @pending_loan.each do |project_id, loan_amount|
      output[Project.find(project_id)] = loan_amount
    end
    output
  end

  def calculate_total_cost
    total_cost = 0
    projects.each do |project, loan_amount|
      total_cost += loan_amount.to_i
    end
    total_cost
  end

  def valid?
    !@pending_loan.empty?
  end

  def checkout!(user_id)
    order = Order.create(
      user_id: user_id.to_i,
      total_cost: calculate_total_cost,
      status: 'ordered'
    )
    projects.each do |project, loan_amount|
      Loan.create(
        project_id: project.id,
        order_id: order.id
      )
    end
    order
  end
end
