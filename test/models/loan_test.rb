require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  test "it has valid attributes" do
    loan = create(:loan)

    assert loan.project_id
    assert loan.order_id
  end

  test "it is not valid without a project id" do
    loan = build(:loan, project_id: nil)
    # loan.update_attributes(project_id: nil)

    assert loan.invalid?
  end

  test "it is not valid without an order id" do
    loan = create(:loan)
    loan.update_attributes(order_id: nil)

    assert loan.invalid?
  end

  test "it is not valid without an amount" do
    loan = create(:loan)
    loan.update_attributes(amount: nil)

    assert loan.invalid?
  end

  test "it is not valid less than $10" do
    loan = create(:loan, amount: 999, order_id: 1, project_id: 1)

    assert loan.invalid?
  end

  test "it is valid with a loan of $20" do
    loan = build(:loan, amount: 2000)

    assert loan.valid?
  end
end
