class UpdatedItems < ActiveRecord::Migration
  def change
    remove_column :items, :reqpayment_begin
    add_column :items, :repayment_begin, :date
  end
end
