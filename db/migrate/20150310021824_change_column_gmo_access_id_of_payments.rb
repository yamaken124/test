class ChangeColumnGmoAccessIdOfPayments < ActiveRecord::Migration
  def change
    change_column :payments, :gmo_access_id, :string
  end
end
