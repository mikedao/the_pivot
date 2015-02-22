class AddAmountToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :amount, :integer
  end
end
