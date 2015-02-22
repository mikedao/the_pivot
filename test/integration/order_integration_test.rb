require "test_helper"

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "authenticated lender can reach their order history by clicking on
  Loans" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link_or_button "Loans"

    assert_equal user_orders_path(user), current_path
  end

  test "authed lender can see previous order on their Loans page" do
    user = create(:user)
    project = create(:project)
    order = project.orders.create(total_cost: 1000, user_id: user.id,
                                 status: "Completed")
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)

    within("#history") do
      assert page.has_content?(order.id)
    end
  end

  test "authed lender on Loans page can see link to individual loans" do
    user = create(:user)
    project = create(:project)
    order = project.orders.create(:order)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)
    within("#history") do
      assert page.has_link?("Order #{order.id}")
    end
  end

  test "authed lender can go to specific orders from order history" do
    user = create(:user)
    project = create(:project)
    order = project.orders.create(total_cost: 1000, user_id: user.id,
                                 status: "Completed")
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)
    within("#history") do
      click_link_or_button("Order #{order.id}")
    end

    assert user_order_path(user, order), current_path
  end
end
