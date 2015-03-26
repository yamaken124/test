class AddColumnItemStateToSingleLineItems < ActiveRecord::Migration
  def change
    add_column :single_line_items, :payment_state, :integer, default: 0, after: :additional_tax_total
  end
end
