class AddUsedPointToSingleOrderDetails < ActiveRecord::Migration
  def change
    add_column :single_order_details, :used_point, :integer, after: :additional_tax_total, default: 0
  end
end
