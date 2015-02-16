class User < ActiveRecord::Base
  has_secure_password

  belongs_to :tenant
  has_many :orders

  validates :password, :first_name, :last_name, presence: true
  validates :username, uniqueness: true, length: { in: 2..32, allow_nil: true }
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :country, presence: true

  def valid_email?(email)
    email_checker(email)
  end

  def full_name
    first_name + " " + last_name
  end

  def borrower?
    !tenant_id.nil?
  end

  def lender?
    tenant_id.nil?
  end

  def admin?
    false
  end

  private

  def email_checker(email)
    email.match(/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/)
  end
end
