class ChangeColumnUsedPointOfPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :used_point
    add_column :payments, :used_point, :integer, null:false, default: 0, after: :amount
  end
end
