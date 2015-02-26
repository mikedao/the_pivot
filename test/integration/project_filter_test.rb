require "test_helper"

class ProjectFilterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a user can view project filters" do
    project = create(:project)
    visit projects_path
    click_link_or_button("Filter Projects")

    assert_equal projects_path, current_path
    within("#filters") do
      assert page.has_content?(project.categories.first.name)
    end
  end
end
