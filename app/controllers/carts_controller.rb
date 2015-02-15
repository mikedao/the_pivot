class CartsController < ApplicationController
  def create
    update_cart
    flash[:notice] = "Added to Cart"
    redirect_to projects_path
  end

  def showcart
    @cart = Cart.new(session[:cart]) if session[:cart]
  end

  def checkout_cart
    if current_user.nil?
      flash[:alert] = "You must login to checkout"
      redirect_to showcart_path
    else
      cart = Cart.new(session[:cart])
      total_cost = 0
      cart.projects.each do |project, quantity|
        total_cost += project.price * quantity.to_i
      end

      @order = Order.create(
        user_id: session[:user_id],
        total_cost: total_cost,
        status: "ordered"
        )
      cart.projects.each do |project, quantity|
        Loan.create(
          project_id: project.id,
          order_id: @order.id,
          quantity: quantity,
          line_item_cost: project.price * quantity.to_i
          )
      end
      session.delete(:cart)
      redirect_to user_order_path(user_id: session[:user_id], id: @order.id)
    end
  end

  def delete_project
    if params[:cart].nil?
      delete_all_projects_from_cart
    else
      delete_specific_project_from_cart
      flash[:notice] = "Project removed from cart"
    end
    redirect_to showcart_path
  end

  def update_project_quantity
    session[:cart][params[:update_project_quantity][:project_id]] =
      params[:update_project_quantity][:quantity]
    flash[:notice] = "Project quantity updated"
    redirect_to showcart_path
  end

  private

  def update_cart
    if session[:cart]
      update_existing_cart
    else
      session[:cart] = { params[:cart][:project_id] =>
                         params[:cart][:quantity] }
    end
  end

  def update_existing_cart
    if session[:cart][params[:cart][:project_id]]
      session[:cart][params[:cart][:project_id]] =
      (session[:cart][params[:cart][:project_id]].to_i +
      params[:cart][:quantity].to_i).to_s
    else
      session[:cart][params[:cart][:project_id]] = params[:cart][:quantity].to_s
    end
  end

  def delete_all_projects_from_cart
    session.delete(:cart)
  end

  def delete_specific_project_from_cart
    session[:cart].delete(params[:cart][:project_id])
  end
end
