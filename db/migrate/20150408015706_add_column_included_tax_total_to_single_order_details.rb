class AddColumnIncludedTaxTotalToSingleOrderDetails < ActiveRecord::Migration
  def change
    add_column :single_order_details, :included_tax_total, :integer, after: :tax_rate_id
  end
end
