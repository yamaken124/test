class AddAccessIdAndAccessPassToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :gmo_access_id, :integer, after: :source_type
    add_column :payments, :gmo_access_pass, :string, after: :gmo_access_id
  end
end
