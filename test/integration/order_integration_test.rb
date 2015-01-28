require 'test_helper'

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user, :order, :item

  def setup
    @user = User.create(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com')
    @item = Item.create(title: 'Pour Over', description: 'blah', price: 1000)
    @order = item.orders.create(total_cost: 1000, user_id: user.id)
    @order.item_orders.first.update(quantity: 1, line_item_cost: 1000)
    visit root_url
  end

  test "user can view his orders page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button 'Cart'
    assert current_path, showcart_path
    click_link_or_button 'Order History'
    assert current_path, user_orders_path(user)
    within ('#history') do
      assert page.has_content?("Order #{order.id}")
    end
  end

  test "user can view page for specific order" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button 'Cart'
    click_link_or_button 'Order History'
    click_link_or_button "Order #{order.id}"
    assert current_path, user_order_path(user, order)
    within ('#history') do
      assert page.has_content?('Pour Over')
    end
  end
end
