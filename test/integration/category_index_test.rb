require "test_helper"

class CategoryIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "Categories index page does not display a category
  that has no associated projects" do
    category = create(:category)

    visit root_path

    refute page.has_content?(category.name)
  end

  test "Categories index page does display a category that
  has an associated project" do
    # the factory for project automatically creates an associated 
    # category
    project = create(:project)
    category = project.categories.first

    visit root_path

    assert page.has_content?(category.name)
  end
end
