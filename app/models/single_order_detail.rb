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
  has_one    :payment

  before_save :ensure_updated_shipments
  before_save :ensure_updated_adjustment
  before_save :set_completed_on

  accepts_nested_attributes_for :single_line_items
  accepts_nested_attributes_for :payment, update_only: false

  validates :used_point,
    numericality: {
      less_than_or_equal_to: :total
    }

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
    self.completed_on = self.completed_at.to_date if !self.completed_at.nil?
  end

  def update_tax_adjustments
    self.additional_tax_total = (item_total * valid_tax_rate.amount).floor
    self.adjustment_total     = additional_tax_total
  end

  def valid_tax_rate
    if tax_rate.nil? || tax_rate.invalid?
      valid_tax = TaxRate.valid.first
      self.tax_rate_id = valid_tax.id
      valid_tax
    else
      tax_rate
    end
  end

end