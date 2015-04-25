class ChangeColumnDescriptionOfHowToUseProduct < ActiveRecord::Migration
  def change
    change_column :how_to_use_products, :description, :text
  end
end
