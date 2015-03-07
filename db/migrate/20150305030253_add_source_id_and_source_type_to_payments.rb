class AddSourceIdAndSourceTypeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :source_id, :integer, after: :amount
    add_column :payments, :source_type, :string, after: :source_id
  end
end
