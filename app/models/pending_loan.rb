class PendingLoan
  include ActionView::Helpers::NumberHelper

  def initialize(pending_loan)
    @pending_loan = pending_loan
  end
  
  def present?
    @pending_loan.present?
  end

  def pending_total
    @pending_loan.values.inject(0) do |sum, loan_amount|
      sum + loan_amount.to_i
    end
  end

  def formatted_pending_total
    number_to_currency(pending_total / 100.00)
  end

  def checkout!(user_id)
    order = Order.create(
      user_id: user_id.to_i,
      status: "ordered"
    )
    @pending_loan.each do |project_id, loan_amount|
      Loan.create(
        amount: loan_amount,
        project_id: project_id,
        order_id: order.id
      )
    end
    order
  end
end
