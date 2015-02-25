require 'test_helper'

class ProjectIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "pagination renders on page" do
		15.times do
			create(:project)
		end

		visit projects_path

		assert page.has_content?("Next")
		assert page.has_content?("Previous")
	end

  test "when user clicks on 'Next' button they are taken to
	the next 10 projects in the index" do
		15.times do
			create(:project)
		end

		visit projects_path
		click_link_or_button("Next", match: :first)

		assert "/projects?page=2", current_path
	end

  test "when user clicks on 'Previous' button they are taken back
	to the previous 10 projects" do
		15.times do
			create(:project)
		end

		visit projects_path
		click_link_or_button("Next", match: :first)
		click_link_or_button("Previous", match: :first)

		assert "/projects?page=1", current_path
	end
end
