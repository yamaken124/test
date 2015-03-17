class RemoveColumnNumberOfSingleOrderDetail < ActiveRecord::Migration
  def change
    remove_column :single_order_details, :number, :string
  end
end
