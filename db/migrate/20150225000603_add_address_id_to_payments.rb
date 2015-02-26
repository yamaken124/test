class AddAddressIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :address_id, :integer, index: true, after: :payment_method_id
    add_foreign_key :payments, :addresses
  end
end
