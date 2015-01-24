require 'test_helper'

class UserTest < ActiveSupport::TestCase
  attr_reader :user, :order

  def setup
    @user = User.create(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com')
    @order = Order.create(total_cost: 100,
                          user_id: user.id)
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

  test "user is not valid with empty strings as name" do
    user.first_name = ""
    user.last_name = ""
    assert user.invalid?
  end

  test "user is not valid without last name" do
    @user.last_name = nil
    assert @user.invalid?
  end

  test "user is not valid without email" do
    @user.email = nil
    assert @user.invalid?
  end

  test "user has a display name that is optional between 2 and 32 characters" do
    @user1 = User.create(username: 'user',
            password: 'password',
            first_name: 'John',
            last_name: 'Doe',
            display_name: "JohnDoe",
            email: 'example@example.com')

    @user2 = User.create(username: 'user',
            password: 'password',
            first_name: 'John',
            last_name: 'Doe',
            display_name: "J",
            email: 'example@example.com')

    @user3 = User.create(username: 'user',
            password: 'password',
            first_name: 'John',
            last_name: 'Doe',
            display_name: "ThisStringIs38charslongCanYouBelieveIt",
            email: 'example@example.com')

    @user4 = User.create(username: 'user',
            password: 'password',
            first_name: 'John',
            last_name: 'Doe',
            email: 'example@example.com')

    assert @user1.valid?
    assert @user2.invalid?
    assert @user3.invalid?
    assert @user4.valid?
  end

  test 'an email has to be vaild format' do
    email1 = @user.email
    assert @user.valid_email?(email1)
    email2 = 'here@here@you'
    refute @user.valid_email?(email2)
    email3 = "eskimo.eskimo@eskimo"
    refute user.valid_email?(email3)
  end

  test "a user has an order" do
    order = user.orders.first
    assert_equal 100, order.total_cost
  end
end
