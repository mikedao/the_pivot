require "test_helper"

class ProjectFilterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a user can view project filters" do
    project = create(:project)
    visit projects_path
    click_link_or_button("Filter Projects")

    assert_equal projects_path, current_path
    within("#project-filters") do
      assert page.has_content?(project.categories.first.name)
      assert page.has_content?("$0 - $100")
      assert page.has_content?("$100 - $500")
      assert page.has_content?("$500+")
      assert page.has_content?(project.tenant.location)
    end
  end
end
