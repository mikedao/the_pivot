require "test_helper"

class TenantProjectsIndexTest < ActionDispatch::IntegrationTest
	include Capybara::DSL
	include FactoryGirl::Syntax::Methods

	authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    tenant.projects << create(:project)
end