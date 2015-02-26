class ChangeColumnSkuOfVariants < ActiveRecord::Migration
  def change
    change_column :variants, :sku, :string, null: false, default: "all"
  end
end
