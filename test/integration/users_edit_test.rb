require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "unsuccessful edit" do
    user = create(:user)
    get edit_user_path(user)
    assert_template 'users/edit'
    patch user_path(user), user: { username: "",
                                   email: "foo@invalid",
                                   password:              "foo",
                                   password_confirmation: "bar" }
    refute flash.empty?
    assert_template 'users/edit'
  end

  test "successful edit" do
    user = create(:user)
    get edit_user_path(user)
    assert_template 'users/edit'
    first_name  = "Jeffrey"
    last_name  = "Jeffrey"
    email  = "Jwan622@yahoo.com"
    city  = "Staten Island"
    state  = "New York"
    zipcode = 10305
    street = "31 Hillwood Court"
    country = "USA"
    credit_card_info = 4141414141414141
    patch user_path(user), { user: { name:  name,
                                   email:   email,
                                   password:              "",
                                   password_confirmation: ""
                                   }
                           }
    assert_not flash.empty?
    assert page.has_content?("Invalid Profile Edit. Try Again")
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
  end
end
