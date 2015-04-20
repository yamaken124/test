class CreateProductDescriptions < ActiveRecord::Migration
  def change
    create_table :product_descriptions do |t|
      t.references :product, index: true
      t.string :description
      t.string :nutritionist_explanation
      t.string :nutritionist_word
      t.timestamps null: false
    end
  end
end
