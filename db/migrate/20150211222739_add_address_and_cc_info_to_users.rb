class AddAddressAndCcInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :credit_card_info, :string
  end
end
