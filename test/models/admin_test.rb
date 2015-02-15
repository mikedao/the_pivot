require "test_helper"

class AdminTest < ActiveSupport::TestCase
  test "admin has attributes" do
    admin = build(:admin)
    assert admin.valid?
  end

  test "admin is not valid without password" do
    admin = build(:admin, password: nil)

    assert admin.invalid?
  end

  test "admin is not valid with a short or long password" do
    admin1 = build(:admin, password: "short")
    admin2 = build(:admin, password: "a" * 25 + "@bob.com")

    assert admin1.invalid?
    assert admin2.invalid?
  end

  test "admin is not valid without a username" do
    admin = build(:admin, username: nil)

    assert admin.invalid?
  end

  test "admin is not valid with a long username" do
    admin = build(:admin, username: "a" * 51)

    assert admin.invalid?
  end

  test "admin is not valid with a short username" do
    admin = build(:admin, username: "a" * 2)

    assert admin.invalid?
  end

  test "admin is not valid without email" do
    admin = build(:admin, email: nil)

    assert admin.invalid?
  end

  test "admin is not valid with a long email" do
    admin = build(:admin, email: "a" * 256)

    assert admin.invalid?
  end

  test "admin is not valid with a short email" do
    admin = build(:admin, email: "a@a.o")

    assert admin.invalid?
  end

  test "username must be unique" do
    create(:admin, username: "bob")
    dup_admin = build(:admin, username: "bob")

    assert dup_admin.invalid?
  end

  test "email must be unique" do
    create(:admin, email: "bob@bob.com")
    dup_admin = build(:admin, email: "bob@bob.com")

    assert dup_admin.invalid?
  end

  test "an email has to be vaild format" do
    admin = build(:admin)
    invalid_emails = ["here@here@you", "eskimo.eskimo@eskimo",
                      "bob!who@who.com", "bob@who#ami.com"]
    assert admin.valid_email?(admin.email)
    invalid_emails.each do |email|
      refute admin.valid_email?(email)
    end
  end
end
