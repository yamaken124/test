class CreateOncePurchaseProductHistories < ActiveRecord::Migration
  def change
    create_table :once_purchase_product_histories do |t|
      t.references :product, index: true
      t.references :user, index: true
      t.datetime :purhcased_at

      t.timestamps null: false
    end
  end
end
