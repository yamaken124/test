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
#  payment_state          :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class SingleLineItem < ActiveRecord::Base

  include SingleLineItem::Transition

  before_validation :invalid_quantity_check
  has_many :returned_items
  belongs_to :variant
  belongs_to :single_order_detail
  # belongs_to :tax_rate

  scope :except_canceled, -> { where.not(payment_state: SingleLineItem.payment_states[:canceled]) }
  scope :canceled_items, -> { where(payment_state: SingleLineItem.payment_states[:canceled]) }

  after_save :destroy_if_order_detail_is_blank, if: Proc.new { |item| item.quantity.zero? }

  def update_tax_adjustments
    additional_tax_total = (price * quantity).floor
    # additional_tax_total = (price * quantity * valid_tax_rate.amount).floor
  end

  # def valid_tax_rate
  #   if tax_rate.nil? || tax_rate.invalid?
  #     TaxRate.valid.first
  #   else
  #     tax_rate
  #   end
  # end

  def destroy_if_order_detail_is_blank
    destroy
  end

  def invalid_quantity_check
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def self.complete_items(single_order_detail)
    single_order_detail.single_line_items.update_all(payment_state: self.payment_states[:completed])
  end

  def cancel_item(payment)
    begin
      ActiveRecord::Base.transaction do
        other_items = payment.single_order_detail.single_line_items.where.not(id: self.id)
        if other_items.blank? || other_items.except_canceled.blank? #注文自体をキャンセル
          payment.shipment.canceled!
          payment.canceled!
        end
        canceled!
      end
      UserMailer.delay.send_order_canceled_notification(self)
    end
  end

end
