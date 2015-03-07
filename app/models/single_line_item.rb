# == Schema Information
#
# Table name: single_line_items
#
#  id                     :integer          not null, primary key
#  variant_id             :integer
#  single_order_detail_id :integer
#  quantity               :integer
#  price                  :integer
#  tax_rate_id            :integer
#  additional_tax_total   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class SingleLineItem < ActiveRecord::Base
  before_validation :invalid_quantity_check
  belongs_to :variant
  belongs_to :single_order_detail
  belongs_to :tax_rate

  after_save :destroy_if_order_detail_is_blank, if: Proc.new { |item| item.quantity.zero? }

  def update_tax_adjustments
    additional_tax_total = (price * quantity * valid_tax_rate.amount).floor
  end

  def valid_tax_rate
    if tax_rate.nil? || tax_rate.invalid?
      TaxRate.valid.first
    else
      tax_rate
    end
  end

  def destroy_if_order_detail_is_blank
    destroy
  end

  def invalid_quantity_check
    self.quantity = 0 if quantity.nil? || quantity < 0
  end
end
