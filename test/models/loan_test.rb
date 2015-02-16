require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  test "it has valid attributes" do
    loan = create(:loan)

    assert loan.project_id
    assert loan.order_id
  end

  test "it is not valid without a project id" do
    loan = build(:loan, project_id: nil)

    assert loan.invalid?
  end

  test "it is not valid without an order id" do
    loan = build(:loan, order_id: nil)

    assert loan.invalid?
  end
end
