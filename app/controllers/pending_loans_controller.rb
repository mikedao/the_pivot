class PendingLoansController < ApplicationController
  def create
    update_cart
    flash[:notice] = "Added to Pending Loans"
    redirect_to pending_loan_path
  end

  def show
    @pending_loans = {}
    if session[:pending_loan]
      session[:pending_loan].each do |project_id, loan_amount|
        @pending_loans[Project.find(project_id.to_i)] = loan_amount
      end
    end
  end

  def checkout_pending_loans
    if current_user.nil?
      flash[:alert] = "You must login to checkout"
      redirect_to pending_loan_path
    else
      redirect_to user_create_order_path(user_id: current_user.id)
    end
  end

  def delete_pending_loan
    delete_specific_project_from_cart
    flash[:notice] = "Project removed from cart"
    redirect_to pending_loan_path
  end

  def destroy
    session.delete(:pending_loan) if session[:pending_loan]
    flash[:notice] = "Pending Loans Removed"
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
    if session[:pending_loan][params[:pending_loan][:project_id]]
      session[:pending_loan][params[:pending_loan][:project_id]] =
      (session[:pending_loan][params[:pending_loan][:project_id]].to_i +
      params[:pending_loan][:quantity].to_i).to_s
    else
      session[:pending_loan][params[:pending_loan][:project_id]] =
      params[:pending_loan][:quantity].to_s
    end
  end

  def delete_specific_project_from_cart
    session[:pending_loan].delete(params[:pending_loan][:project_id])
  end
end
