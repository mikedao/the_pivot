require "test_helper"

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a guest user can view a home page" do
    project = create(:project)

    visit root_path

    assert page.has_link?(project.categories.first.name)
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

  test "a guest user can see all projects for a specific category after clicking
  that category on the home page" do
    user = create(:user)
    project = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link_or_button(project.categories.first.name)

    assert_equal category_path(id: project.categories.first.id), current_path
    assert page.has_content?(project.title)
    assert page.has_content?(project.categories.first.name)
  end

  test "a guest user can view a tenant projects page" do
    project1 = create(:project)
    project2 = create(:project)

    visit root_path
    click_link_or_button("#{project1.categories.first.name}")
    click_link_or_button(project1.title)

    assert_equal tenant_project_path(
      slug: project1.tenant.slug,
      id: project1.id
    ), current_path
    project1.categories.each do |category|
      assert page.has_link?(category.name)
    end
    refute page.has_content?(project2.tenant.organization)
    refute page.has_content?(project2.title)
    refute page.has_content?(project2.categories.first.name)
  end

  test "a guest user can view a tenant page" do
    project1 = create(:project)

    visit tenant_path(slug: project1.tenant.slug)

    project1.categories.each do |category|
      assert page.has_link?(category.name)
    end
  end

  test "a user can go back to the projects page from the tenant page" do
    project1 = create(:project)

    visit tenant_path(slug: project1.tenant.slug)
    first(".project-category").
      click_link_or_button(project1.categories.first.name)

    assert_equal projects_path, current_path
  end

  test "user will be redirected to home page if tenant does not exist" do
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

  test "after an unauthorized user adds items and clicks checkout and logs in,
  the pending_loans still retains the items" do
    user = create(:user)
    project = create(:project)
    visit root_path
    click_link_or_button("#{project.categories.first.name}")
    within(".row") do
      click_link_or_button("Lend")
    end
    fill_in "session[username]", with: user.username
    fill_in "session[password]", with: user.password
    click_link_or_button("Login")
    visit pending_loan_path

    within("#pending_loans") do
      click_button("Checkout")
    end

    assert page.has_content?("You have successfully completed your loans.")
    assert_equal user_order_path(user_id: user.id, id: user.orders.first.id),
                 current_path
    assert page.has_content?(user.orders.first.total_cost / 100)
    assert page.has_content?(user.orders.first.status)
    assert page.has_content?(project.title)
    assert page.has_content?(project.price / 100)
  end

  test "while on project show page for a specific tenant, I can click the
  tenant link to go to the tenant index page" do
    project = create(:project)
    project.tenant.projects << Project.create!(
      title: "Lucy's factory farm",
      price: 20000,
      description: "We raise cheap meat for restaurants across America. We
                    cows, cheap, goats, and chickens. We also sell eggs and milk
                    and various dairy products for restaurants as well.",
      retired: false,
      categories: [create(:category)],
      photos: [create(:photo)],
      requested_by: Date.new(2015,1,1)
      )

    visit tenant_project_path(slug: project.tenant.slug, id: project.tenant.projects.first.id)
    click_link_or_button(project.tenant.organization)

    project.tenant.projects.each do |project|
      assert page.has_css?("div#project_#{project.id}")
    end
  end
end
