class AddColumnStockQuantityToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :stock_quantity, :integer, after: :is_invalid_at, default: 0
  end
end
