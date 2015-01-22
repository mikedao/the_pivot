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
    @order = Order.create(total_cost: 100, user_id: user.id)
    @item = order.items.create(title: 'Pour Over')
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
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button 'Cart'
    click_link_or_button 'Order History'
    save_and_open_page
    click_link_or_button "Order #{order.id}"
    assert current_path, user_order_path(user, order)
    save_and_open_page
    within ('#order_history') do
      assert page.has_content?('Pour Over')
    end
  end

  test "link to each item exists" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit orders_path
    click_link_or_button ' Page'
  end
end
