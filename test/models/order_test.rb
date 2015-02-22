require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "an order has attributes" do
    order = create(:order)
    user = order.user

    assert order.valid?
    assert_equal 0, order.total_cost
    assert_equal user.id, order.user_id
  end


  test "an order is not valid without all attributes" do
    order1 = build(:order, total_cost: nil)
    order2 = build(:order, user_id: nil)

    assert order1.invalid?
    assert order2.invalid?
  end

  test "an order has a user" do
    order = create(:order)
    user_first_name = order.user.first_name

    assert_equal "Roger1", user_first_name
  end

  test "an order has projects associated with it" do
    order = create(:order_with_loan)

    assert_equal 1, order.projects.count
  end

  test "an order's total cost is the sum of all the loan amounts" do
    order = create(:order)
    3.times { order.loans << create(:loan, amount: 1500) }

    assert_equal 4500, order.total_cost
  end
end
