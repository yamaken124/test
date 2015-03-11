class AddColumnNumberToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :number, :string, after: :single_order_detail_id
  end
end
