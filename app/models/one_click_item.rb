class OneClickItem < ActiveRecord::Base

  belongs_to :purchase_order
  belongs_to :variant
  has_one :one_click_payment

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
