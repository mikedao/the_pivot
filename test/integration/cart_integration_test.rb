require "test_helper"

class CartIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    FactoryGirl.reload
  end

  test "a cart starts empty" do
    visit "/"
    click_link_or_button("Cart")

    within("#pending_loans") do
      assert page.has_content?("You Have No Pending Loans")
    end
  end

  test "an unauthorized user can add an project to the cart" do
    tenant = create(:tenant)
    tenant.projects << create(:project)
    visit "/#{tenant.organization}"

    within(".row") do
      click_link_or_button("Lend")
    end

    within("#flash_notice") do
      assert page.has_content?("Added to Pending Loans")
    end
  end

  test "an unauthorized user with projects in their cart can view their cart" do
    tenant = create(:tenant)
    tenant.projects << create(:project)

    visit "/#{tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end

    within("#pending_loans") do
      assert page.has_content?("espresso")
      assert page.has_content?("1")
    end

  end

  test "an unauthorized user can add different projects to the cart and
        show the correct price" do
    project1 = create(:project)
    project2 = create(:project)

    visit "/#{project1.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    visit "/#{project2.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end

    within("#pending_loans") do
      assert page.has_content?(project1.title)
      assert page.has_content?(project1.price)
      assert page.has_content?(project2.title)
      assert page.has_content?(project2.price)
    end
  end

  test "an unauthorized user cannot checkout until logged in" do
    project = create(:project)

    visit "/#{project.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Checkout")
    within("#flash_alert") do
      assert page.has_content?("You must login to checkout")
    end

    assert_equal pending_loan_path, current_path
  end

  test "a user can delete an project from their cart" do
    project = create(:project)

    visit "/#{project.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Delete")

    within("#flash_notice") do
      assert page.has_content?("Project removed from cart")
    end

    refute page.has_content?(project.title)
    assert_equal pending_loan_path, current_path
  end

  test "a user can empty their cart" do
    project1 = create(:project)
    project2 = create(:project)

    visit "/#{project1.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    visit "/#{project2.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Empty Cart")

    within("#flash_notice") do
      assert page.has_content?("Pending Loans Removed")
    end
    refute page.has_content?(project1.title)
    refute page.has_content?(project2.title)
    assert_equal pending_loan_path, current_path
  end

  test "project titles on cart page are links" do
    project = create(:project)

    visit "/#{project.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button(project.title)

    assert_equal tenant_project_path(slug: project.tenant.organization,
                                     id: project.id), current_path
  end

  test "an authenticated user can add default amount to their cart" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project)

    visit "/#{tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end

    assert_equal "/pending_loan", current_path
    within("#pending_loans") do
      assert page.has_content?(tenant.projects.first.title)
      assert page.has_content?("25")
    end
  end

  test "authed user can select a diff amt for a loan add it to their cart" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project, price: 5000)

    visit "/#{tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end

    assert_equal "/pending_loan", current_path
    within("h1") do
      assert page.has_content?("Pending Loans")
    end
    within("#pending_loans") do
      assert page.has_content?(tenant.organization)
      assert page.has_content?(tenant.projects.first.title)
      assert page.has_content?("50")
    end
  end

  test "a user can checkout once logged in" do
    skip
    project = create(:project)
    user = create(:user)
        
    visit "/#{project.tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    fill_in "session[username]", with: user.username
    fill_in "session[password]", with: user.password
    click_link_or_button("Login")
    click_link_or_button("Cart")
    click_link_or_button("Checkout")

    assert_equal user_order_path(user_id: user.id,
                                 id: user.orders.first.id), current_path
    assert page.has_content?(project.price)
    assert page.has_content?(project.title)
  end

  test "an authenticated user can delete a pending loan from their cart" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project)

    visit "/#{tenant.organization}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Delete")

    within("#pending_loans") do
      refute page.has_content?(tenant.projects.first.title)
      refute page.has_content?("25")
    end
  end
end
