class AddColumnPaidTotalToSingleOrderDetails < ActiveRecord::Migration
  def change
    add_column :single_order_details, :paid_total, :integer, after: :total
  end
end
