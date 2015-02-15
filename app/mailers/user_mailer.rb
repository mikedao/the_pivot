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
end
