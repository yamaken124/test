class OneClickItem < ActiveRecord::Base

  belongs_to :variant
  belongs_to :one_click_detail
  has_one :one_click_shipment

  def cancel_item
    # begin
    #   ActiveRecord::Base.transaction do
        # order has_one item
        one_click_detail.one_click_payment.canceled!
        one_click_shipment.canceled!
      # end
      # UserMailer.delay.send_item_canceled_notification(self)
    #   true
    # rescue
    #   false
    # end
  end

  def self.register_with_purchase_order(order,params)
    item = OneClickItem.new(
      variant_id: params[:variant_id],
      purchase_order_id: order.id,
      quantity: params[:quantity],
      price: Variant.find(params[:variant_id]).price.amount,
      )
    item.save!
    item
  end
end
