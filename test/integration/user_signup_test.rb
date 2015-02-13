require "test_helper"

class CreateAUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "a user can be created, and is automatically logged in" do
    visit new_user_path
    fill_in "signup[username]", with: "username"
    fill_in "signup[first_name]", with: "firstname"
    fill_in "signup[last_name]", with: "lastname"
    fill_in "signup[street]", with: "street"
    fill_in "signup[city]", with: "city"
    fill_in "signup[state]", with: "state"
    fill_in "signup[zipcode]", with: "zipcode"
    fill_in "signup[country]", with: "country"
    fill_in "signup[password]", with: "password"
    fill_in "signup[password_confirmation]", with: "password"
    fill_in "signup[email]", with: "email@example.com"

    click_link_or_button "Create Account"

    assert_equal root_path, current_path
    assert page.has_content?("firstname")
  end

  test "a guest user is returned to signup page if details invalid" do
    visit new_user_path
    fill_in "signup[username]", with: "username"

    click_link_or_button "Create Account"

    assert_equal new_user_path, current_path
    assert page.has_content?("Please try again.")
  end
end
