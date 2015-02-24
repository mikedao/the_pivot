require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an unauthorized user when they unsuccessfully edit their profiel gets
  returned back to the profile edit view with an error" do
    user = create(:user)
    get edit_user_path(user)
    assert_template "users/edit"
    patch user_path(user), user: { username: "",
                                   email: "foo@invalid",
                                   password: "foo",
                                   password_confirmation: "bar" }
    refute flash.empty?
    assert_template "users/edit"
  end

  test "an authorized borrower or lender can successfully edit their profile" do
    user = create(:user)

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
end
