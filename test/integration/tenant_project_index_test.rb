require "test_helper"

class TenantProjectsIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "pagination renders at the top and bottom of the page" do
  	authenticated_user = create(:user_as_borrower)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    11.times do
    	tenant.projects << create(:project)
    end
  	visit tenant_projects_path(slug: tenant.slug)

  	assert page.has_content?("Previous")
  	assert page.has_content?("Next") 
  end

  test "the 'Next' link takes user to the next page of projects
  and that the 'Previous' link takes the user back" do
  	skip
  	authenticated_user = create(:user_as_borrower)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    11.times do
    	tenant.projects << create(:project)
    end
  	visit tenant_projects_path(slug: tenant.slug)

  	assert page.has_content?("De Beers9")
  end

end