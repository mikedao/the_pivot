class User < ActiveRecord::Base
  has_secure_password

  has_many :orders

  validates :password, :first_name, :last_name, presence: true
  validates :username, length: { in: 2..32, allow_nil: true }
  validates :email, uniqueness: { case_sensitive: false }, presence: true

  enum role: [:default, :admin]

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

  def full_name
    first_name + " " + last_name
  end
end
