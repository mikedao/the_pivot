require "test_helper"

class BorrowerTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "a borrower can view a home page" do
    visit root_path

    assert page.has_content?("Keevahh")
  end

  test "a borrower can see all their projects" do
    borrower = create(:user_as_borrower)
    tenant = borrower.tenant
    tenant.projects << create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(borrower)

    visit tenant_dashboard_path(slug: tenant.slug)

    tenant.projects.each do |project|
      assert page.has_content?(project.title)
      assert page.has_content?(project.formatted_dollar_amount)
    end
  end

  test "a borrower is redirected to their dashboard upon login" do
    borrower = create(:user_as_borrower)

    visit root_url
    fill_in "session[username]", with: borrower.username
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"

    assert_equal tenant_dashboard_path(slug: borrower.tenant.slug), current_path
  end

  test "a borrower can create an project" do
    category = create(:category)
    borrower = create(:user_as_borrower)
    ApplicationController.any_instance.stubs(:current_user).returns(borrower)
    visit tenant_dashboard_path(slug: borrower.tenant.slug)

    click_link_or_button("New Project")
    fill_in "project[title]", with: "New Water Project for our town"
    fill_in "project[price]", with: 40004
    fill_in "project[description]",  with: "a" * 150
    file_path = Rails.root + "app/assets/images/froth.jpg"
    attach_file("project[photos]", file_path)
    select category.name, from: "project[categories][]"
    click_button "Create Project"

    assert page.has_content?("New Water Project for our town")
  end

  test "a borrower can update an project" do
    borrower = create(:user_as_borrower)
    tenant = borrower.tenant
    tenant.projects << create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(borrower)
    visit tenant_dashboard_path(slug: borrower.tenant.slug)

    click_link_or_button("Edit")
    assert_equal edit_tenant_project_path(slug: tenant.slug,
                                          id: tenant.projects.last.id),
                 current_path
    fill_in "project[title]", with: "Updated Water Project for our town"
    fill_in "project[price]", with: 40004
    fill_in "project[description]", with: "a" * 150
    file_path = Rails.root + "app/assets/images/froth.jpg"
    attach_file("project[photos]", file_path)
    select Category.first.name, from: "project[categories][]"
    click_button "Update"

    assert page.has_content?("Updated Water Project for our town")
  end

  test "a borrower can only see their own projects on the dashboard" do
  end

  test "a borrower cannot see anyone else's dashboard" do
  end
end
