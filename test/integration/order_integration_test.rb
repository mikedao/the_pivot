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
    order = create(:order_with_loan)
    user = order.user
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)

    within("#history") do
      assert page.has_content?(order.id)
    end
  end

  test "authed lender on Loans page can see link to individual loans" do
    order = create(:order_with_loan)
    user = order.user
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)
    within("#history") do
      assert page.has_link?("Order #{order.id}")
    end
  end

  test "authed lender can go to specific orders from order history" do
    order = create(:order_with_loan)
    user = order.user
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_orders_path(user)
    within("#history") do
      click_link_or_button("Order #{order.id}")
    end

    assert user_order_path(user, order), current_path
  end

  test "an authed lender can see loan details on each order page" do
    order = create(:order_with_loan)
    user = order.user
    order.loans << create(:loan, amount: 3500)
    loan1 = order.loans.first
    loan2 = order.loans.second
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_order_path(user, order)
    assert page.has_content?(order.final_total / 100)
    assert page.has_content?(loan1.amount / 100)
    assert page.has_content?(loan1.project.tenant.location)
    assert page.has_content?(loan2.amount / 100)
  end

  test "an authed lender can click to go to each project page from the order
        page" do
    order = create(:order_with_loan)
    user = order.user
    project = order.projects.first

    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit user_order_path(user, order)
    click_link_or_button(project.title)

    assert_equal tenant_project_path(slug: project.tenant.slug, id: project.id),
                 current_path
  end
end
