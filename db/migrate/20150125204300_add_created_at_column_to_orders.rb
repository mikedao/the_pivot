class AddCreatedAtColumnToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :created_at, :datetime, null: false
    add_column :orders, :updated_at, :datetime, null: false
  end

  def down
    remove_column :orders, :created_at
    remove_column :orders, :updated_at
  end
end
