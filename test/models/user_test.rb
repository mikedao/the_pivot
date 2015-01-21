require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com')
  end

  test "user has attributes" do
    assert @user.valid?
  end

  test "user is not valid without username" do
    @user.username = nil
    assert @user.invalid?
  end

  test "user is not valid without password" do
    @user.password = nil
    assert @user.invalid?
  end

  test "user is not valid without first name" do
    @user.first_name = nil
    assert @user.invalid?
  end

  test "user is not valid without last name" do
    @user.last_name = nil
    assert @user.invalid?
  end

  test "user is not valid without email" do
    @user.email = nil
    assert @user.invalid?
  end

  test 'an email has to be vaild format' do
    email1 = @user.email
    assert @user.valid_email?(email1)
    email2 = 'here@here@you'
    refute @user.valid_email?(email2)
  end

  test "a user has an order" do
    order_total_cost = user.order.total_cost
    assert_equal 
  end
end
