require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  attr_reader :order, :user, :item

  def setup
    @user = User.create(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com')
    @order = Order.create(total_cost: 5, user_id: user.id)
  end

  test 'an order has attributes' do
    assert order.valid?
    assert_equal 5, order.total_cost
    assert_equal user.id, order.user_id
  end


  test  'an order is not valid without all attributes' do
    order.total_cost = nil
    assert order.invalid?
    order.user_id = nil
    assert order.invalid?
  end

  test 'an order has a user' do
    user_first_name = order.user.first_name
    assert_equal 'John', user_first_name
  end

  test "order has items associated with it" do
    item = order.items.create(title: 'coffee')
    assert_equal 'coffee', order.items.first.title
  end
end
