class RenameItemOrdersLoans < ActiveRecord::Migration
  def change
    rename_table :item_orders, :loans
  end
end
