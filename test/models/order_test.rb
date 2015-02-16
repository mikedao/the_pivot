require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "an order has attributes" do
    order = create(:order, total_cost: 505)
    user = order.user

    assert order.valid?
    assert_equal 505, order.total_cost
    assert_equal user.id, order.user_id
  end


  test "an order is not valid without all attributes" do
    order1 = build(:order, total_cost: nil)
    order2 = build(:order, user_id: nil)

    assert order1.invalid?
    assert order2.invalid?
  end

  test "an order has a user" do
    order = create(:order, total_cost: 505)
    user_first_name = order.user.first_name

    assert_equal "Roger1", user_first_name
  end

  test "an order has projects associated with it" do
    project = create(:project, title: "water")
    order = create(:order)
    order.projects << project

    assert_equal "water", order.projects.first.title
  end

  test "an order's total cost must be a reasonable positive integer" do
    invalid_orders = [build(:order, total_cost: 0, user_id: 5),
                      build(:order, total_cost: "ablj", user_id: 5),
                      build(:order, total_cost: -120, user_id: 5),
                      build(:order, total_cost: 13.4, user_id: 5),
                      build(:order, total_cost: 10**6, user_id: 5),
                      build(:order, total_cost: "   ", user_id: 5)]

    invalid_orders.each do |order|
      assert order.invalid?
    end
  end
end
