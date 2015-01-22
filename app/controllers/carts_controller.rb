class CartsController < ApplicationController
  def update
    session[:cart] = { params[:id] => 1 }
    flash[:notice] = 'Added to Cart'
    redirect_to item_path(params[:id])
  end
end
