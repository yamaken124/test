class AddColumnVariants < ActiveRecord::Migration
  def change
    add_column :variants, :order_type, :tinyint, after: :product_id
  end
end
