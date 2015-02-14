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
end
