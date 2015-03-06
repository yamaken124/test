class ChangeColumnUsedPointOfPayments < ActiveRecord::Migration
  def change
	change_column :payments, :used_point, :integer, null:false, default: 0
  end
end
