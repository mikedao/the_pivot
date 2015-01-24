class CartsController < ApplicationController
  def checkout_cart
    if session[:user_id].nil?
      flash[:alert] = 'You must login to checkout'
      redirect_to showcart_path
    else
      require "pry"; binding.pry
      # redirect_to user_orders_path(id: session[:user_id])
    end
  end

  def create
    update_cart
    flash[:notice] = 'Added to Cart'
    redirect_to items_path
  end

  def showcart
    @cart = Cart.new(session[:cart]) if session[:cart]
  end

  private

  def update_cart
    if session[:cart]
      update_existing_cart
    else
      session[:cart] = { params[:cart][:id] => params[:cart][:quantity] }
    end
  end

  def update_existing_cart
    if session[:cart][params[:cart][:id]]
      session[:cart][params[:cart][:id]] = (session[:cart][params[:cart][:id]].to_i + params[:cart][:quantity].to_i).to_s
    else
      session[:cart][params[:cart][:id]] = params[:cart][:quantity].to_s
    end
  end

end
