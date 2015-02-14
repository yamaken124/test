class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.integer :parent_id
      t.integer :positon
      t.string :name
      t.string :permalink
      t.integer :taxonomy_id
      t.text :description

      t.timestamps null: false
    end
  end
end
