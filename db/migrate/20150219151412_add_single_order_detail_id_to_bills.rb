class AddSingleOrderDetailIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :single_order_detail_id, :integer, after: :id
  end
end
