class OneClickItem < ActiveRecord::Base

  belongs_to :variant
  belongs_to :one_click_detail
  has_one :one_click_shipment

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

  def can_canceled?
    one_click_detail.one_click_payment.completed? && (one_click_shipment.ready? if one_click_shipment.present?) && variant.active?
  end

  def cancel_item
    begin
      ActiveRecord::Base.transaction do
        one_click_detail.one_click_payment.canceled!
        if variant.belongs_to_one_click_shippment_taxons?
          one_click_shipment.canceled!
          variant.update_stock_quantity(quantity)
        end
      end
      UserMailer.delay.send_one_click_item_canceled_notification(self)
    end
  end


end
