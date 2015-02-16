class Admin < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true,
                       uniqueness: true,
                       length: { in: 3..50 }
  validates :email, presence: true,
                    uniqueness: true,
                    length: { in: 6..255 }
  validates :password, length: { in: 8..25 }, allow_nil: true

  def valid_email?(email)
    email_checker(email)
  end

  private

  def email_checker(email)
    email.match(/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/)
  end
end
