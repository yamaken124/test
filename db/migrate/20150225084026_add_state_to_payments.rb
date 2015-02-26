class AddStateToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :state, :integer, after: :single_order_detail_id, default: 0
  end
end
