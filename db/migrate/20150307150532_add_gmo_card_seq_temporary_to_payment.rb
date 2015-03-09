class AddGmoCardSeqTemporaryToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :gmo_card_seq_temporary, :integer, after: :gmo_access_pass
  end
end
