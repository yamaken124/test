class Bill < ActiveRecord::Base
  belongs_to :address
  belongs_to :single_order_detail

  def update_bill
    update(
      item_total: single_order_detail.item_total,
      additional_tax_total: single_order_detail.additional_tax_total,
      shipment_total: single_order_detail.shipment_total,
      total: single_order_detail.total,
      updated_at: Time.now
    )
  end
end
