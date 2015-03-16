class AddShippedAtAndTrackingToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :tracking, :string, :after => :address_id
    add_column :shipments, :shipped_at, :datetime, :after => :tracking
  end
end
