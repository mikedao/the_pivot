class PendingLoan
  def initialize(pending_loan)
    @pending_loan = pending_loan
  end

  def projects
    output = {}
    @pending_loan.each do |project_id, loan_amount|
      output[Project.find(project_id.to_i)] = loan_amount.to_i
    end
    output
  end
end
