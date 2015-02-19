# == Schema Information
#
# Table name: bills
#
#  id                     :integer          not null, primary key
#  single_order_detail_id :integer
#  address_id             :integer
#  item_total             :integer
#  total                  :integer
#  shipment_total         :integer
#  additional_tax_total   :integer
#  used_point             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

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
