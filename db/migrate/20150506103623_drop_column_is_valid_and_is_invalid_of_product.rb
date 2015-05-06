class DropColumnIsValidAndIsInvalidOfProduct < ActiveRecord::Migration
  def change
    remove_column :products, :is_valid_at, :datetime
    remove_column :products, :is_invalid_at, :datetime
  end
end
