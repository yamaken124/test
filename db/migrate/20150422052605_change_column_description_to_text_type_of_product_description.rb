class ChangeColumnDescriptionToTextTypeOfProductDescription < ActiveRecord::Migration
  def change
    remove_column :product_descriptions, :description, :varchar
    add_column :product_descriptions, :description, :text, after: :product_id
  end
end
