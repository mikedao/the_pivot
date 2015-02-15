require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome borrower email is proper" do
    tenant = create(:tenant)
    tenant.user <<  create(:user)
    user = tenant.user.first

    mail = UserMailer.welcome_borrower(user)

    assert_equal "Welcome to Keevahh, Borrower!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["michael.dao@gmail.com"], mail.from
    assert_match "borrower", mail.body.encoded
  end

  test "welcome lender email is proper" do
    user = create(:user, tenant_id: nil)

    mail = UserMailer.welcome_lender(user)

    assert_equal "Welcome to Keevahh, Lender!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["michael.dao@gmail.com"], mail.from
    assert_match "lender", mail.body.encoded
  end
end
