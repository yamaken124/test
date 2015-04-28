class CreateHowToUseProducts < ActiveRecord::Migration
  def change
    create_table :how_to_use_products do |t|
      t.references :product, index: true
      t.string :description
      t.integer :position
      t.timestamps null: false
    end
  end
end
