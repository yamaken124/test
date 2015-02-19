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
