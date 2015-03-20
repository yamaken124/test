class AddLftAndRgtWithIndexToTaxons < ActiveRecord::Migration
  def change

    add_column :taxons, :lft, :integer, null: false, after: :description
    add_column :taxons, :rgt, :integer, null: false, aftes: :lft

    add_index :taxons, :parent_id
    add_index :taxons, :lft
    add_index :taxons, :rgt

  end
end
