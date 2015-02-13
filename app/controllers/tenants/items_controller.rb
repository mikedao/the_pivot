class Tenants::ItemsController < ApplicationController
  include ItemsHelper

  def index
    @tenant = Tenant.find_by(slug: params[:slug])

    redirect_to root_path if @tenant.nil?

    if params[:category_name] == 'Shop All' || params[:category_name].nil?
      @items = Item.active
    else
      @items = Category.find_by(name: params[:category_name]).items
    end
    @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.create(item_params)
    add_category(params[:item][:categories])
    redirect_to items_path
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    redirect_to admin_items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, :price, :description, :retired,
                                 :tenant_id, :repayment_begin, :repayment_rate)
  end
end
