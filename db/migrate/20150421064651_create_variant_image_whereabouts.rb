class CreateVariantImageWhereabouts < ActiveRecord::Migration
  def change
    create_table :variant_image_whereabouts do |t|

      t.references :image, index: true
      t.references :variant, index: true
      t.integer :whereabout

      t.timestamps null: false
    end
  end
end
