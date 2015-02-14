class PendingLoan
  def initialize(pending_loan)
    @pending_loan = pending_loan
  end

  def items
    output = {}
    @pending_loan.each do |item_id, loan_amount|
      output[Item.find(item_id)] = loan_amount
    end
    output
  end
end
