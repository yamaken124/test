class AddCoulumnUserIdToPayments < ActiveRecord::Migration
  def change
	add_column :payments, :user_id, :integer, after: :single_order_detail_id
  end
end
