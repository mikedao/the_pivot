require "test_helper"

class ProjectIndexTest < ActionDispatch::IntegrationTest
	include Capybara::DSL
	include FactoryGirl::Syntax::Methods

	test "pagination renders on the page" do
		15.times do
			create(:project)
		end

		visit projects_path

		assert page.has_content?("Previous")
		assert page.has_content?("Next")
	end
end