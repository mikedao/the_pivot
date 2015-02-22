class AddFundsAvailableToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :amount_needed, :integer
  end
end
