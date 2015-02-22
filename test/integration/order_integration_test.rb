require "test_helper"

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user, :project

  def setup
    @user = create(:user)
    @project = create(:project)
    visit root_url
  end

  test "user can view his orders page" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button "Cart"
    assert current_path, showcart_path
    click_link_or_button "Order History"
    assert current_path, user_orders_path(user)
    within ("#history") do
      assert page.has_content?("Order #{order.id}")
    end
  end

  test "user can view page for specific order" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button "Cart"
    click_link_or_button "Order History"
    click_link_or_button "Order #{order.id}"
    assert current_path, user_order_path(user, order)
    within ("#history") do
      assert page.has_content?("Pour Over")
    end
  end
end
