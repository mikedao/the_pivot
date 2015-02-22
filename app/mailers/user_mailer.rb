class UserMailer < ApplicationMailer
  default from: "michael.dao@gmail.com"

  def welcome_borrower(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Keevahh, Borrower!"
  end

  def welcome_lender(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Keevahh, Lender!"
  end

  def pending_borrower_alert(user)
    @user = user
    Admin.all.each do |admin|
      mail to: admin.email, subject: "Pending Borrower"
    end
  end

  def approved_borrower(user, tenant)
    @user = user
    @tenant = tenant
    mail to: @user.email, subject: "Your Organization has been approved!"
  end
end
