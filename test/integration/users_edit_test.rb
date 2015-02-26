require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an authorized borrower or lender can successfully edit their profile" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    
    get edit_user_path(user)
    assert_template "users/edit"
    username = "Jwan622"
    first_name = "Jeffrey"
    last_name = "Jeffrey"
    email = "Jwan622@yahoo.com"
    city = "Staten Island"
    state = "New York"
    zipcode = 10305
    street = "31 Hillwood Court"
    credit_card_info = 4141414141414141
    patch user_path(user), { user: { username: username,
                                     first_name: first_name,
                                     last_name: last_name,
                                     email: email,
                                     city: city,
                                     state: state,
                                     zipcode: zipcode,
                                     street: street,
                                     credit_card_info: credit_card_info,
                                     password: "Ilikematzoh",
                                     password_confirmation: "Ilikematzoh"
                                    }
                           }
    user.reload

    assert_not flash.empty?
    assert_equal user.username, username
    assert_equal user.email, email
  end

  test "when a user tries to edit their profile and doesn't enter a password,
    street, or username he gets redirected back to the edit view with an
    informative password error message" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit edit_user_path(user)
    click_button("Save changes")

    assert page.has_content?("Update Your Profile")
    assert page.has_content?("Password can't be blank")

    fill_in "user[username]", with: ""
    fill_in "user[password]", with: "Ienjoykumquats"
    fill_in "user[password_confirmation]", with: "Ienjoykumquats"
    click_button("Save changes")

    assert page.has_content?("Username can't be blank")

    visit edit_user_path(user)
    fill_in "user[street]", with: ""
    fill_in "user[password]", with: "Ienjoykumquats"
    fill_in "user[password_confirmation]", with: "Ienjoykumquats"
    click_button("Save changes")

    assert page.has_content?("Street can't be blank")
  end

  test "when a user tries to edit their profile can doesn't enter matching
    passwords, the edit view gets rendered with an informative message" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit edit_user_path(user)
    fill_in "user[password]", with: "OMGClayAiken"
    fill_in "user[password_confirmation]", with: "OMGClayAiken1"
    click_button("Save changes")

    assert page.has_content?("Password confirmation doesn't match Password")
  end
end
