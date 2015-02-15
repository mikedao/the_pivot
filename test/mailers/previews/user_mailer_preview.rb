# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_borrower
    user = User.last
    UserMailer.welcome_borrower(user)
  end

  def welcome_lender
    user = User.last
    UserMailer.welcome_lender(user)
  end

end
