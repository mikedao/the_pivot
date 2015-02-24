require "test_helper"

class ProjectIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "pagination renders at the top and bottom of the page" do
  	11.times do
  		create(:project)
  	end

  	visit projects_path

  	assert page.has_content?("Previous")
  	assert page.has_content?("Next") 
  end

  test "the 'Next' link takes user to the next page of projects
  and that the 'Previous' link takes the user back" do
  	11.times do
  		create(:project)
  	end

  	visit projects_path

  	click_link_or_button("Next", match: :first)
  	assert page.has_content?("De Beers11")
  	click_link_or_button("Previous", match: :first)
  	assert page.has_content?("De Beers1")
  end

end