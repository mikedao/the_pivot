class UpdateUsers < ActiveRecord::Migration
  def change
    remove_column :users, :address

    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
    add_column :users, :country, :string
    add_column :users, :credit_card_digest, :string
    add_reference :users, :tenant, index: true
  end
end
