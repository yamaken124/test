class CreateUserCategoriesTaxons < ActiveRecord::Migration
  def change
    create_table :user_categories_taxons do |t|

      t.references :user_category, index: true
      t.references :taxon, index: true

      t.timestamps null: false
    end
  end
end
