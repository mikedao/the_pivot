class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :total_cost
      t.integer :user_id
    end
  end
end
