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
      requested_by: Date.new(2015, 1, 1)
      )

    visit tenant_project_path(slug: project.tenant.slug, id: project.tenant.projects.first.id)
    click_link_or_button("Other Projects from this Borrower")

    project.tenant.projects.each do |project|
      assert page.has_css?("div#project_#{project.id}")
    end
  end

end
