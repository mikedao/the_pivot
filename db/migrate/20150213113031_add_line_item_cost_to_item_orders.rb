class AddLineItemCostToItemOrders < ActiveRecord::Migration
  def change
    add_column :item_orders, :line_item_cost, :integer
  end
end
