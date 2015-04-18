class OneClickPayment < ActiveRecord::Base

  belongs_to :payment_method
  belongs_to :address
  belongs_to :user
  belongs_to :one_click_item

  def pay_with_gmo_payment #FIXME concern model
    access = GmoMultiPayment::Transaction.new(self).sales_entry
    self.gmo_access_id = access[:access_id]
    self.gmo_access_pass = access[:access_pass]
    return GmoMultiPayment::Transaction.new(self).exec(self.gmo_card_seq_temporary)
  end

  def self.register_with_one_click_item(item, params, current_user)
    address = Address.last #FIXME
    number = "o" + Time.now.to_i.to_s + item.id.to_s

    payment = OneClickPayment.new(
      amount: Variant.find(params[:variant_id]).price.amount,
      payment_method_id: 1,
      gmo_card_seq_temporary: 0,#FIXME
      address_id: address.id,
      used_point: 1000,
      payment_method_id: 1,
      one_click_item_id: item.id,
      user_id: current_user.id,
      number: number,
      )

    raise 'gmo_transaction_failed' unless payment.pay_with_gmo_payment
    payment.save!
    payment
  end

end
