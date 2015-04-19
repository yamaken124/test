# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  item_total           :integer          default(0), not null
#  tax_rate_id          :integer
#  total                :integer          default(0), not null
#  paid_total           :integer
#  completed_on         :date
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer          default(0), not null
#  additional_tax_total :integer          default(0), not null
#  used_point           :integer          default(0)
#  adjustment_total     :integer          default(0), not null
#  item_count           :integer          default(0), not null
#  lock_version         :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class SingleOrderDetail < ActiveRecord::Base
  belongs_to :single_order
  belongs_to :address
  # belongs_to :tax_rate
  has_many   :single_line_items
  has_one    :payment

  before_save :ensure_updated_shipments
  before_save :ensure_updated_adjustment
  before_save :set_completed_on

  accepts_nested_attributes_for :single_line_items
  accepts_nested_attributes_for :payment, update_only: false

  paginates_per 5

  def single_payment
    payment ||= self.build_payment
  end

  def ensure_updated_shipments
    # if shipments.any? && !self.completed?
      # self.shipments.destroy_all
      # self.update_column(:shipment_total, 0)
      # restart_checkout_flow
    # end
  end

  def ensure_updated_adjustment
  end

  def set_completed_on
    self.completed_on = self.completed_at.to_date unless self.completed_at.nil?
  end

  def update_tax_adjustments
    # self.additional_tax_total = (item_total * valid_tax_rate.amount).floor
    # self.additional_tax_total = (item_total * valid_tax_rate.amount).floor
    # self.adjustment_total = additional_tax_total
  end

  def can_send_back?
    Date.today - self.completed_on <= 14
  end

  def item_total_with_tax
    item_total.to_i# + additional_tax_total.to_i
  end

  def allowed_max_use_point
    if single_line_items.any? {|item| item.prohibit_using_mileage?}
      0
    else
      [item_total_with_tax, single_order.purchase_order.user.wellness_mileage, Payment::UsedPointLimit].min
    end
  end

  def identical_tracking_number(items_id = single_line_items.ids)
    items = single_line_items.where(id: items_id)
    expecting_tracking = items.first.shipment.tracking
    expecting_tracking if items.all? {|item| item.shipment.tracking == expecting_tracking}
  end

  def all_shipped?
    single_line_items.all? { |item| item.shipment.shipped? }
  end

end
