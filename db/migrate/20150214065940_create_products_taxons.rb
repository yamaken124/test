class CreateProductsTaxons < ActiveRecord::Migration
  def change
    create_table :products_taxons do |t|
      t.references :product, index: true
      t.integer :taxon_id
      t.integer :position

      t.timestamps null: false
    end
    add_foreign_key :products_taxons, :products
  end
end
