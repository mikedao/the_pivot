class PendingLoansController < ApplicationController
  def create
    update_cart
    flash[:notice] = "Added to Pending Loans"
    redirect_to pending_loan_path
  end

  def show
    @pending_loans = {}
    if pending_loans_exist?
      session[:pending_loan].each do |project_id, loan_amount|
        @pending_loans[Project.find(project_id.to_i)] = loan_amount
      end
    else
      @pending_loans
    end
  end

  def update
    session[:pending_loan][params[:pending_loan][:project_id]] =
    params[:pending_loan][:loan_dollar_amount].to_f * 100
    flash[:notice] = "Project loan amount updated"
    redirect_to pending_loan_path
  end

  def destroy
    session.delete(:pending_loan) if session[:pending_loan]
    flash[:notice] = "Pending Loans Removed"
    redirect_to pending_loan_path
  end

  def delete_one
    if params[:pending_loan].nil?
      delete_all_projects_from_cart
    else
      delete_specific_project_from_cart
      flash[:notice] = "Project removed from cart"
    end
    redirect_to pending_loan_path
  end

  private

  def pending_loan_params
    params.require(:pending_loan).permit(:project_id, :loan_amount)
  end

  def update_cart
    if session[:pending_loan]
      update_existing_cart
    else
      session[:pending_loan] = {
        pending_loan_params[:project_id] =>
          pending_loan_params[:loan_amount]
      }
    end
  end

  def update_existing_cart
    if loan_is_already_pending
      update_specific_loan
    else
      session[:pending_loan][pending_loan_params[:project_id]] =
      pending_loan_params[:loan_amount].to_s
    end
  end

  def loan_is_already_pending
    session[:pending_loan][pending_loan_params[:project_id]]
  end

  def pending_loans_exist?
    session[:pending_loan] != nil
  end

  def delete_all_projects_from_cart
    session.delete(:pending_cart)
  end

  def delete_specific_project_from_cart
    session[:pending_loan].delete(pending_loan_params[:project_id])
  end
end
