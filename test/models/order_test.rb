require "test_helper"

class OrderTest < ActiveSupport::TestCase
  attr_reader :order, :user, :project

  def setup
    @order = create(:order, total_cost: 5, user_id: user.id)
  end

  test "an order has attributes" do
    assert order.valid?
    assert_equal 5, order.total_cost
    assert_equal user.id, order.user_id
  end


  test "an order is not valid without all attributes" do
    order.total_cost = nil
    assert order.invalid?
    order.user_id = nil
    assert order.invalid?
  end

  test "an order has a user" do
    user_first_name = order.user.first_name
    assert_equal "John", user_first_name
  end

  test "order has projects associated with it" do
    order.projects.create(title: "coffee",
                          description: "akjdf",
                          price: 203921)
    assert_equal "coffee", order.projects.first.title
  end
end
