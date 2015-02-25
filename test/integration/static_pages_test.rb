require "test_helper"

class StaticPagesTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a guest can visit the about page in the footer on any page" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit root_path
    click_link("About")

    assert_equal about_path, current_path
    assert page.has_content?("What is Keevahh?")

    visit user_path(user)
    click_link("About")

    assert_equal about_path, current_path
    assert page.has_content?("What is Keevahh?")
  end
end
