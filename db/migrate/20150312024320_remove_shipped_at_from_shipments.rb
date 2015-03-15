class RemoveShippedAtFromShipments < ActiveRecord::Migration
  def change
    remove_column :shipments, :shopped_at, :datetime
  end
end
