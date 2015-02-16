require "test_helper"

class BorrowerTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "a borrower can view a home page" do
    visit root_path

    assert page.has_content?("Keevahh")
  end

  test "a borrower can see all their projects" do
    borrower = create(:user)
    tenant = create(:tenant)
    tenant.projects << create(:project)
    borrower.tenant_id = tenant.id
    ApplicationController.any_instance.stubs(:current_user).returns(borrower)

    visit tenant_dashboard_path(slug: tenant.slug)

    tenant.items.each do |item|
      assert page.has_content?(item.title)
      assert page.has_content?("$8.01")
    end
  end

  test "a borrower is redirected to their dashboard upon login" do
  end

  test "a borrower can create an item" do
  end

  test "a borrower can update an item" do
  end

  test "a borrower can edit an item" do
  end

  test "a borrower can only see their own projects on the dashboard" do
  end

  test "a borrower cannot see anyone else's dashboard" do
  end
end
