require "test_helper"

class UserTest < ActiveSupport::TestCase
  attr_reader :user

  test "user has attributes" do
    user = build(:user)

    assert user.valid?
  end

  test "user is valid even without username" do
    user = build(:user, username: nil)

    assert user.valid?
  end

  test "user is not valid without password" do
    user = build(:user, password: nil)

    assert user.invalid?
  end

  test "user is not valid without first name" do
    user = build(:user, first_name: nil)

    assert user.invalid?
  end

  test "user is not valid without last name" do
    user = build(:user, last_name: nil)

    assert user.invalid?
  end

  test "user is not valid with empty strings as name" do
    user = build(:user, first_name: "")

    assert user.invalid?
  end

  test "user is not valid with empty last name" do
    user = build(:user, last_name: "")

    assert user.invalid?
  end

  test "user is not valid without street" do
    user = build(:user, street: nil)

    assert user.invalid?
  end

  test "user is not valid without city" do
    user = build(:user, city: nil)

    assert user.invalid?
  end

  test "user is not valid without state" do
    user = build(:user, state: nil)

    assert user.invalid?
  end

  test "user is not valid without email" do
    user = build(:user, email: nil)

    assert user.invalid?
  end

  test "user has an optional username that is between 2 and 32 characters" do
    user1 = build(:user)
    user2 = build(:user, username: "u")
    user3 = build(:user, username: "ThisStringIs42CharactersLongBelieveItOrNot")

    assert user1.valid?
    assert user2.invalid?
    assert user3.invalid?
  end

  test "an email has to be vaild format" do
    user = build(:user)

    email1 = user.email
    assert user.valid_email?(email1)
    email2 = "here@here@you"
    refute user.valid_email?(email2)
    email3 = "eskimo.eskimo@eskimo"
    refute user.valid_email?(email3)
  end

  test "full name is actually full name" do
    user = build(:user)

    assert_equal "Roger Federer", user.full_name
  end

  test "it knows if it is a borrower" do
    tenant = create(:tenant)
    tenant.user << create(:user)
    user = tenant.user.first

    assert user.borrower?
    refute user.lender?
  end

  test "it knows if it is a lender" do
    user = create(:user)

    assert user.lender?
    refute user.borrower?
  end
end
