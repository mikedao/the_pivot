class PendingLoansController < ApplicationController
  def create
    update_cart
    flash[:notice] = "Added to Pending Loans"
    redirect_to pending_loan_path
  end

  def show
    @pending_loans = {}
    session[:pending_loan].each do |project_id, loan_amount|
      @pending_loans[Project.find(project_id.to_i)] = loan_amount
    end
  end

  def checkout_pending_loans
    if current_user.nil?
      flash[:alert] = "You must login to lend money"
      redirect_to pending_loan_path
    else
      redirect_to create_order_path
    end
  end

  def delete_pending_loan
    if params[:pending_loan].nil?
      delete_all_projects_from_cart
    else
      delete_specific_project_from_cart
      flash[:notice] = "Project removed from cart"
    end
    redirect_to pending_loan_path
  end

  def update_project_amount
    session[:pending_loan][params[:update_pending_loan_amount][:project_id]] =
       params[:update_pending_loan_amount][:loan_amount]
    flash[:notice] = "Project loan amount updated"
    redirect_to pending_loan_path
  end

  private

  def update_cart
    if session[:pending_loan]
      update_existing_cart
    else
      session[:pending_loan] = {
        params[:pending_loan][:project_id] =>
         params[:pending_loan][:loan_amount]
      }
    end
  end

  def update_existing_cart
    if loan_is_already_pending
      update_specific_loan
    else
      session[:pending_loan][params[:pending_loan][:project_id]] =
      params[:pending_loan][:loan_amount].to_s
    end
  end

  def loan_is_already_pending
    session[:pending_loan][params[:pending_loan][:project_id]]
  end

  def update_specific_loan
    session[:pending_loan][params[:pending_loan][:project_id]] =
    session[:pending_loan][params[:pending_loan][:project_id]]
  end

  def delete_all_projects_from_cart
    session.delete(:pending_cart)
  end

  def delete_specific_project_from_cart
    session[:pending_loan].delete(params[:pending_loan][:project_id])
  end
end
