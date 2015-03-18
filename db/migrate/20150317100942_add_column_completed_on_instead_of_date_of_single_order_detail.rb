class AddColumnCompletedOnInsteadOfDateOfSingleOrderDetail < ActiveRecord::Migration
  def change
    remove_column :single_order_details, :date, :date
    add_column :single_order_details, :completed_on, :date, after: :total
  end
end
