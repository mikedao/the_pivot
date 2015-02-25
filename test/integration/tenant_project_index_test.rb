require 'test_helper'

class TenantProjectIndexTest < ActionDispatch::IntegrationTest
	include Capybara::DSL
	include FactoryGirl::Syntax::Methods

	test "pagination renders on page" do
		authenticated_user = create(:user)
		ApplicationController.any_instance.stubs(:current_user).
			returns(authenticated_user)
		tenant = create(:tenant)
		15.times do
			tenant.projects << create(:project)
		end

		visit tenant_projects_path(slug: tenant.slug)

		assert page.has_content?("Previous")
		assert page.has_content?("Next")
	end

end