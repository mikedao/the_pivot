class Project < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  scope :active, -> { where(retired: false) }

  has_many :projects_categories
  has_many :categories, through: :projects_categories
  has_many :photos
  has_many :loans, after_add: :calculate_amount_needed,
                   before_add: :check_amount_needed
  has_many :orders, through: :loans
  belongs_to :tenant

  validates :description, length: { in: 100..255, allow_nil: false },
                          presence: true
  validates :title, presence: true, uniqueness: true, allow_blank: false
  validates :price, presence: true,
                    numericality:
                    {
                      only_integer: true,
                      greater_than: 999,
                      less_than: 100000
                    }
  validates :categories, presence: true

  before_create :add_default_repayment_rate
  before_save :add_default_repayment_begin
  before_create :add_default_amount_needed

  def formatted_dollar_amount
    number_to_currency(price / 100.00)
  end

  def downcase_categories
    categories.map do |category|
      category.name.downcase
    end
  end

  # move this logic
  def as_json(s)
    {
      title: title,
      description: description,
      price: price,
      categories: downcase_categories,
      id: id,
      organization: tenant.slug
    }
  end

  private

  def add_default_repayment_rate
    self.repayment_rate = 26
  end

  def add_default_repayment_begin
    self.repayment_begin = requested_by + 90
  end

  def add_default_amount_needed
    self.amount_needed = price
  end

  def calculate_amount_needed(_loan)
    self.amount_needed = price - loans.map(&:amount).reduce(:+)
  end

  def check_amount_needed(loan)
    if loans.present?
      calculate_amount_needed(loan)
    else
      add_default_amount_needed
    end
  end
end
