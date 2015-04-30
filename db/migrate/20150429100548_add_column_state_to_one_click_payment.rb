class AddColumnStateToOneClickPayment < ActiveRecord::Migration
  def change
    add_column :one_click_payments, :state, :integer, after: :user_id
  end
end
