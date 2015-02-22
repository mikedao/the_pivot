require "test_helper"
class PendingLoanTest < ActiveSupport::TestCase
  test "it can calculate total cost" do
    project1 = create(:project)
    project2 = create(:project)
    pending_loans_in_session = {
      project1.id.to_s => project1.price.to_s,
      project2.id.to_s => project2.price.to_s
    }
    pending_loans = PendingLoan.new(pending_loans_in_session)

    manually_calculated_total_cost = project1.price + project2.price

    assert_equal manually_calculated_total_cost,
                 pending_loans.pending_total
  end

  test "it can return the projects and their associated loan amount" do
    project1 = create(:project)
    project2 = create(:project)
    pending_loans_in_session = {
      project1.id.to_s => project1.price.to_s,
      project2.id.to_s => project2.price.to_s
    }
    pending_loans = PendingLoan.new(pending_loans_in_session)

    assert_includes pending_loans.projects, project1
    assert_includes pending_loans.projects, project2
    assert_equal project1.price, pending_loans.projects[project1]
    assert_equal project2.price, pending_loans.projects[project2]
  end

  test "it knows when it's present" do
    pending_loans = PendingLoan.new({})

    refute pending_loans.present?
  end

  test "it can checkout" do
    user = create(:user)
    project1 = create(:project)
    project2 = create(:project)
    pending_loans_in_session = {
      project1.id.to_s => project1.price.to_s,
      project2.id.to_s => project2.price.to_s
    }
    pending_loans = PendingLoan.new(pending_loans_in_session)

    pending_loans.checkout!(user.id)

    assert_equal 2, Order.first.loans.count
    assert_equal 2, Order.first.projects.count
    assert_equal user.id, Order.first.user_id
  end
end
