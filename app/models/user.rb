class User < ActiveRecord::Base
  has_many :orders
  
  has_secure_password
  validates :username, :password, :first_name, :last_name, :email, presence: true

  def valid_email?(email)
    if email_checker(email).nil?
      false
    else
      true
    end
  end

  def email_checker(email)
    email.match(/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/)
  end
end
