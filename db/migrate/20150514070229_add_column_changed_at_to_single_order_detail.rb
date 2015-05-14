class AddColumnChangedAtToSingleOrderDetail < ActiveRecord::Migration
  def change
    add_column :single_order_details, :order_changed_at, :datetime, after: :completed_at
  end
end
