class PendingLoansController < ApplicationController
  def create
    #it starts here for the session cart.
    update_cart
    redirect_to pending_loan_path
  end

  def show
    @pending_loans = {}
    if session[:pending_loan].present?
      session[:pending_loan].each do |project_id, loan_amount|
        @pending_loans[Project.find(project_id.to_i)] = loan_amount
      end
    end
  end

  def update
    if valid_loan_amount(pending_project_amount)
      session[:pending_loan][pending_loan_params[:project_id]] =
        pending_loan_params[:loan_dollar_amount].to_f * 100
      flash[:notice] = "Project loan amount updated"
    else
      flash[:notice] = notice(pending_project_amount)
    end
    redirect_to pending_loan_path
  end

  def destroy
    session.delete(:pending_loan) if session[:pending_loan]
    flash[:notice] = "Pending Loans Removed"
    redirect_to pending_loan_path
  end

  def delete_one
    delete_project_from_cart
    flash[:notice] = "Project removed from cart"
    redirect_to pending_loan_path
  end

  private

  def pending_loan_params
    params.require(:pending_loan).permit(:project_id,
                                         :loan_amount,
                                         :loan_dollar_amount)
  end

  def pending_project_amount
    Project.find(pending_loan_params[:project_id]).current_amount_needed
  end

  def update_cart
    if session[:pending_loan]
      update_existing_cart
    else
      session[:pending_loan] = {
        pending_loan_params[:project_id] => pending_loan_params[:loan_amount]
      }
    end
  end

  def update_existing_cart
    session[:pending_loan][pending_loan_params[:project_id]] =
      pending_loan_params[:loan_amount].to_s
  end

  def delete_project_from_cart
    session[:pending_loan].delete(pending_loan_params[:project_id])
  end

  def valid_loan_amount(remaining_amount)
    require 'pry' ; binding.pry
    amount = pending_loan_params[:loan_dollar_amount].to_f
    if remaining_amount < 1000
      amount == remaining_amount / 100.00
    else
      amount >= 10 && amount <= remaining_amount / 100.00
    end
  end

  def notice(remaining_amount)
    if remaining_amount < 1000
      "Please enter a valid amount of $#{remaining_amount / 100}"
    else
      "Please enter a valid amount between $10
      & $#{remaining_amount / 100}"
    end
  end
end
