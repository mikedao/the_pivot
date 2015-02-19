require "test_helper"

class PendingLoansIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a cart starts empty" do
    visit "/"

    click_link_or_button("Pending Loans")

    within("#pending_loans") do
      assert page.has_content?("You Have No Pending Loans")
    end
  end

  test "an unauthorized user can add an project to the cart" do
    tenant = create(:tenant)
    tenant.projects << create(:project)
    visit "/#{tenant.slug}"

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

    visit "/#{tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end

    within("#pending_loans") do
      assert page.has_content?(tenant.projects.first.title)
    end
  end

  test "an authenticated user can delete an item from the cart" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    project = create(:project)

    visit "/"
    first(".category-name").
      click_link_or_button("#{project.categories.first.name}")
    first(".row").click_button("Lend")

    within("#pending_loans") do
      click_link_or_button("Delete")
    end
    within("#flash_notice") do
      assert page.has_content?("Project removed from cart")
    end

    refute page.has_content?(project.title)
    assert_equal pending_loan_path, current_path
  end

  test "a user can delete an project from their cart" do
    project = create(:project)

    visit "/#{project.tenant.slug}"
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

  test "an unauthorized user can add different projects to the cart and
        show the correct price" do
    project1 = create(:project)
    project2 = create(:project)

    visit "/#{project1.tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    visit "/#{project2.tenant.slug}"
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

    visit "/#{project.tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Checkout")
    within("#flash_alert") do
      assert page.has_content?("You Must Login to Lend Money")
    end

    assert_equal pending_loan_path, current_path
  end

  test "a user can empty their cart" do
    project1 = create(:project)
    project2 = create(:project)

    visit "/#{project1.tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    visit "/#{project2.tenant.slug}"
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

    visit "/#{project.tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button(project.title)

    assert_equal tenant_project_path(slug: project.tenant.slug,
                                     id: project.id), current_path
  end

  test "an authenticated user can add a project to their cart" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project)

    visit "/#{tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end

    assert_equal "/pending_loan", current_path
    within("#pending_loans") do
      assert page.has_content?(tenant.projects.first.title)
      assert page.has_content?(tenant.projects.first.price)
    end
  end

  test "an authed user can a loan with a different amount from the default
        amount provided by the :project factory add it to their cart" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project, price: 5000)

    visit "/#{tenant.slug}"
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
      assert page.has_content?(tenant.projects.first.price)
    end
  end

  test "an unauthenticated user that clicks 'Checkout' is prompted
    to login or create an account" do
    project = create(:project)

    visit "/#{project.tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button "Checkout"

    assert page.has_content?("You Must Login to Lend Money")
  end

  test "a user can checkout once logged in" do
    skip
    project = create(:project)
    user = create(:user)

    visit "/#{project.tenant.slug}"
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
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project)

    visit "/#{tenant.slug}"
    within(".row") do
      click_link_or_button("Lend")
    end
    click_link_or_button("Delete")

    within("#pending_loans") do
      refute page.has_content?(tenant.projects.first.title)
      refute page.has_content?(tenant.projects.first.price)
    end
  end
end
