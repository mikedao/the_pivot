require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome borrower email is proper" do
    tenant = create(:tenant)
    tenant.users <<  create(:user)
    user = tenant.users.first

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

  test "a platform admin new borrower alert email is valid" do
    admin = create(:admin)
    tenant = create(:tenant)
    tenant.users << create(:user)
    user = tenant.users.first

    mail = UserMailer.pending_borrower_alert(user)

    assert_equal "Pending Borrower", mail.subject
    assert_equal [admin.email], mail.to
    assert_equal ["michael.dao@gmail.com"], mail.from
    assert_match "Pending", mail.body.encoded
  end

  test "Tenant approval email is valid" do
    create(:admin)
    tenant = create(:tenant)
    tenant.users << create(:user)
    user = tenant.users.first

    mail = UserMailer.approved_borrower(user, tenant)

    assert_equal "Your Organization has been approved!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["michael.dao@gmail.com"], mail.from
    assert_match "Congratulations", mail.body.encoded
  end
end
