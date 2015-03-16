class AddColumnVariants < ActiveRecord::Migration
  def change
    add_column :variants, :order_type, :integer, limit: 1, after: :product_id
  end
end
