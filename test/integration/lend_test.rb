require "test_helper"

class LendTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "authenticated lender can make a default loan of $25" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    tenant = create(:tenant_visible)
    tenant.projects << create(:project)

    visit "/#{tenant.slug}"
    within(".row") do
      click_link_or_button("Lend $25")
    end

    within("#pending_loans") do
      assert page.has_content?("$25.00")
    end
  end
end
