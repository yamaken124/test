class OneClickPayment < ActiveRecord::Base

  belongs_to :payment_method
  belongs_to :address
  belongs_to :user
  belongs_to :one_click_detail

  def pay_with_gmo_payment #FIXME concern model
    access = GmoMultiPayment::Transaction.new(self).sales_entry
    self.gmo_access_id = access[:access_id]
    self.gmo_access_pass = access[:access_pass]
    return GmoMultiPayment::Transaction.new(self).exec(self.gmo_card_seq_temporary)
  end

end
