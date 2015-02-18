require "test_helper"

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "a guest user can view a home page" do
    project = create(:project)

    visit root_path

    assert page.has_content?(project.categories.first.name)
  end

  test "a guest user can see all the categories for active projects" do
    projects = []
    4.times { |x| projects << create(:project) }
    retired_project = create(:project, retired: true)
    visit root_path

    categories = projects.map do |project|
      project.categories
    end
    categories = categories.flatten
    categories.each do |category|
      assert page.has_content?(category.name)
    end
    refute page.has_content?(retired_project.categories.first.name)
  end

  test "a guest user can see all projects for a category" do
    user = create(:user)
    project = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link_or_button(project.categories.first.name)

    assert_equal category_path(id: project.categories.first.id), current_path
    assert page.has_content?(project.title)
    assert page.has_content?(project.categories.first.name)
  end

  test "an unauthorised user can view a tenant projects page" do
    user = create(:user)
    project = create(:project)
    project.photos << create(:photo)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link_or_button(project.categories.first.name)
    click_link_or_button(project.title)

    assert_equal tenant_project_path(
      slug: project.tenant.organization,
      id: project.id
    ), current_path
    assert page.has_content?(project.tenant.organization)
    assert page.has_content?(project.tenant.location)
    assert page.has_content?(project.title)
    # assert page.has_content?(project.photos.first.url)
    assert page.has_content?(project.description)
    assert page.has_content?(project.price / 100)
    assert page.has_content?(project.categories.first.name)
  end

  test "an unauthorised user can view a tenant projects page which only
    shows their products" do
    user = create(:user)
    project1 = create(:project)
    project2 = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link_or_button(project1.categories.first.name)
    click_link_or_button(project1.title)

    assert_equal tenant_project_path(
      slug: project1.tenant.organization,
      id: project1.id
    ), current_path
    refute page.has_content?(project2.tenant.organization)
    refute page.has_content?(project2.title)
    refute page.has_content?(project2.categories.first.name)
  end

  test "will be redirected to home page if tenant does not exist" do
    visit tenant_path(slug: "made-up-shop")

    assert_equal "/", current_path
  end

  test "a unauthorized user cannot see another user's loan page" do
    loan1 = create(:loan)
    loan2 = create(:loan)
    ApplicationController.any_instance.stubs(:current_user).
      returns(loan1.order.user)

    visit "/users/#{loan2.order.user.id}/orders/"

    refute page.has_content?("Order History")
    refute page.has_content?(loan2.project.title)
  end

  test "an unauthorized user can add projects to pending_loans and see the
  projects on the pending_loans show page" do
    tenant = create(:tenant)
    tenant.projects << create(:project, price: 8900)

    visit root_path
    click_link_or_button "#{tenant.projects.first.categories.first.name}"
    within(".row") do
      click_link_or_button("Lend")
    end

    assert_equal "/pending_loan", current_path
    within("#pending_loans") do
      assert page.has_content?(tenant.projects.first.title)
      assert page.has_content?("#{tenant.projects.first.price}")
    end
  end

  test "an unauthorized user can add projects to pending_loans but cannot
  checkout page logging in" do
    tenant = create(:tenant)
    tenant.projects << create(:project, price: 8900)

    visit root_path

    click_link_or_button("#{tenant.projects.first.categories.first.name}")
    within(".row") do
      click_link_or_button("Lend")
    end
    within("#pending_loans") do
      click_button("Checkout")
    end

    assert page.has_content?("You Must Login to Lend Money")
    assert_equal "/pending_loan", current_path
  end

  test "after an unauthorized user adds items and clicks checkout and logs in,
  the pending_loans still retains the items" do
    skip
  end
end
