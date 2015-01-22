class RemoveCartsTable < ActiveRecord::Migration
  def up
    drop_table :carts
  end

  def down
    create_table :carts
  end
end
