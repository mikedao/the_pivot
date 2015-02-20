require "test_helper"

class CreateAUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "it allows a user to sign up as a lender and is logged in" do
    visit root_path
    click_link_or_button "Signup"

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
    assert page.has_content?("Thank you for creating an account.")
  end

  test "it allows a person to fail signing up and returns to signup page" do
    visit root_path
    click_link_or_button "Signup"
    fill_in "signup[username]", with: "username"

    click_link_or_button "Create Account"

    assert_equal new_user_path, current_path
    assert page.has_content?("Please try again.")
  end

  test "it redirects user to org signup if organization is invalid" do
    visit root_path
    click_link_or_button "Signup"
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
    check "signup[tenant]"
    click_link_or_button "Create Account"

    fill_in "tenant_signup[location]", with: "location"
    click_link_or_button "Create Organization"

    assert_equal new_tenant_path, current_path
  end

  test "it displays an error message if organization is not created" do
    visit root_path
    click_link_or_button "Signup"
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
    check "signup[tenant]"
    click_link_or_button "Create Account"

    fill_in "tenant_signup[location]", with: "location"
    click_link_or_button "Create Organization"

    assert page.has_content?("Please try again.")
  end

  test "it allows a user to fully complete borrower signup" do
    visit root_path
    click_link_or_button "Signup"
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
    check "signup[tenant]"
    click_link_or_button "Create Account"
    fill_in "tenant_signup[location]", with: "location"
    fill_in "tenant_signup[organization]", with: "organization"
    click_link_or_button "Create Organization"

    assert_equal root_path, current_path
    assert page.has_content?("Organization Created.")
  end

  test "a user cannot sign up with a non unique email address" do
    create(:user, email: "test@test.com")
    visit root_path
    click_link_or_button "Signup"
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
    fill_in "signup[email]", with: "test@test.com"
    click_link_or_button "Create Account"

    assert_equal new_user_path, current_path
    assert page.has_content?("Account Already Exists")
  end
end
