class User < ActiveRecord::Base
  has_secure_password

  has_many :orders

  validates :username, :password, :last_name, :email, presence: true
  validates :first_name, length: { in: 0..255, allow_nil: false }
  validates :display_name, length: { in: 2..32, allow_nil: true }

  enum role: [:user, :admin]

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
