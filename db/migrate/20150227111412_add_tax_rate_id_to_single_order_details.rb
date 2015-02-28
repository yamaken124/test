class AddTaxRateIdToSingleOrderDetails < ActiveRecord::Migration
  def change
    add_column :single_order_details, :tax_rate_id, :integer, after: :item_total
    add_foreign_key :single_order_details, :tax_rates
  end
end
