class ChangeColumnsOfProductDescription < ActiveRecord::Migration
  def change
    change_column :product_descriptions, :nutritionist_explanation, :text
    change_column :product_descriptions, :nutritionist_word, :text
  end
end
