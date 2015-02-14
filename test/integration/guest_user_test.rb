require "test_helper"

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "a guest user can view a home page" do
    skip
    visit root_path
    assert page.has_content?("Cinema Coffee")
  end

  test "a guest user can see all projects" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit root_path
    click_link_or_button("Menu")
    assert_equal projects_path, current_path
    assert page.has_content?(project1.title)
    assert page.has_content?(category1.name)
  end

  test "a guest user can browse projects by category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit root_path
    click_link_or_button("Menu")
    click_link_or_button(category1.name)
    assert_equal projects_path, current_path
    assert page.has_content?(project1.title)
    assert page.has_content?(category1.name)
    refute page.has_content?(project2.title)
  end

  test "registered admin can create category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_admin)
    visit admin_dashboard_path
    click_link_or_button "Category"
    fill_in "categories[name]", with: "Blah"
    click_link_or_button "Add Category"
    assert page.has_content?("Blah")
  end

  test "unregistered admin cannot see category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit projects_path
    refute page.has_content?("Create Category")
  end

  test "an unauthorised user can view a single projects page" do
    skip
    Project.create(title: "coffee",
                description: "black nectar of the gods",
                price: 1200)

    visit root_url
    click_link_or_button("Menu")
    click_link_or_button("coffee")

    within("#title") do
      assert page.has_content?("coffee")
    end

    within("#description") do
      assert page.has_content?("black nectar of the gods")
    end

    within("#price") do
      assert page.has_content?("$12.00")
    end
  end

  test "an unauthorised user can view a tenant's page which only shows their
  products" do
    non_tenant_category = create(:category, name: "bad cats")
    tenant_category = create(:category, name: "agriculture")
    non_tenant_project = create(:project, categories: [non_tenant_category])
    tenant = create(:tenant, organization: "bob's")
    tenant_project = create(:project, title: "cats", description: "good",
                         categories: [tenant_category])
    tenant.projects << tenant_project

    visit tenant_path(slug: tenant.slug)

    assert_equal "/bob-s", current_path
    within first(".project-category") do
      assert page.has_content?(tenant_category.name)
      refute page.has_content?(non_tenant_category.name)
    end
    assert page.has_content?(tenant_project.title)
    refute page.has_content?(non_tenant_project.title)
  end

  test "will be redirected to home page if tenant does not exist" do
    visit tenant_path(slug: "made-up-shop")

    assert_equal "/", current_path
  end

  test "an unauthorized user can signup" do
    skip
    visit root_url
    click_link_or_button("Signup")

    fill_in "signup[username]", with: "theChosen1"
    fill_in "signup[password]", with: "gryffendor"
    fill_in "signup[password_confirmation]", with: "gryffendor"
    fill_in "signup[first_name]", with: "Harry"
    fill_in "signup[last_name]", with: "Potter"
    fill_in "signup[email]", with: "RedHeadLover@hogwarts.com"

    click_link_or_button("Create Account")

    assert current_path, root_url
    assert page.has_content?("Welcome, Harry")
  end

  test "if user already exists they can't sign up again" do
    skip
    visit root_url
    click_link_or_button("Signup")

    fill_in "signup[username]", with: "jeff"
    fill_in "signup[password]", with: "wan"
    fill_in "signup[password_confirmation]", with: "wan"
    fill_in "signup[first_name]", with: "Jeff"
    fill_in "signup[last_name]", with: "Wan"
    fill_in "signup[email]", with: "jwan622@example.com"

    click_link_or_button("Create Account")
    within("#flash_notice") do
      assert page.has_content?("Account Already Exists")
    end
  end

  test "a unauthorized user cannot see another user's order page" do
    skip
    order = create(:order)
    user = order.user

    visit "/users/#{user.id}/orders/"

    refute page.has_content?("Order History")

    visit "/users/#{user.id}/orders/#{order.id}"

    refute page.has_content?("Order #{order.id}")
  end
end
