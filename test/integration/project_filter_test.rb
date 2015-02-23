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
      assert page.has_content?("$0 - $100")
      assert page.has_content?("$100 - $500")
      assert page.has_content?("$500+")
    end
  end

  test "a user sees only the category of project selected when
    coming from root path" do
    project1 = create(:project)
    project2 = create(:project)
    project1_category = project1.categories.first.name
    project2_category = project2.categories.first.name
    visit root_path

    click_link_or_button(project1.categories.first.name)
    save_and_open_page

    assert_equal projects_path, current_path
    assert find("#category_#{project1_category.parameterize}").checked?
    refute find("#category_#{project2_category.parameterize}").checked?
    assert page.has_content?(project1.title)
    refute page.has_content?(project2.title)
  end
end