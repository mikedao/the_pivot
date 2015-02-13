class AddQuantityToItemOrders < ActiveRecord::Migration
  def change
    add_column :item_orders, :quantity, :integer
  end
end
