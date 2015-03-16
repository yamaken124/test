class AddColumnNameToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :name, :string, after: :product_id
  end
end
