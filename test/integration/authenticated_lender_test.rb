require "test_helper"

class AuthenticatedLenderTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "authed lender with no pending loans is not shown a call to action" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path

    refute page.has_content?("Help someone today and")
    refute page.has_content?("complete your loan")
  end

  test "authed lender with pending loans is shown a call to action" do
    user = create(:user)
    project = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit "/#{project.tenant.slug}"

    within(".row") do
      click_link_or_button("Lend $25")
    end
    visit root_path

    assert page.has_content?("Help someone today and")
    assert page.has_link?("complete your loan")
  end
end
