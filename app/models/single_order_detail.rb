# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  number               :string(255)
#  item_total           :integer
#  total                :integer
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer
#  additional_tax_total :integer
#  adjustment_total     :integer
#  item_count           :integer
#  date                 :date
#  lock_version         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class SingleOrderDetail < ActiveRecord::Base
  belongs_to :single_order
  belongs_to :address
  belongs_to :tax_rate
  has_one    :bill
  has_many   :single_line_items

  accepts_nested_attributes_for :single_line_items

  def ensure_updated_shipments
    # if shipments.any? && !self.completed?
      # self.shipments.destroy_all
      # self.update_column(:shipment_total, 0)
      # restart_checkout_flow
    # end
  end

end
