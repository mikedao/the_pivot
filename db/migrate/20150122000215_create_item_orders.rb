class CreateItemOrders < ActiveRecord::Migration
  def change
    create_table :item_orders do |t|
      t.integer :item_id
      t.integer :order_id
      t.integer :quantity
      t.integer :line_item_cost

      t.timestamps null: false
    end
  end
end
