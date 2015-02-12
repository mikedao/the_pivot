class UpdateItemOrders < ActiveRecord::Migration
  def change
    remove_column :item_orders, :quantity
    remove_column :item_orders, :line_item_cost
  end
end
