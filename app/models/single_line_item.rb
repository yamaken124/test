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
  has_one :shipment
  belongs_to :variant
  belongs_to :single_order_detail
  # belongs_to :tax_rate

  scope :except_canceled, -> { where.not(payment_state: SingleLineItem.payment_states[:canceled]) }
  scope :canceled_items, -> { where(payment_state: SingleLineItem.payment_states[:canceled]) }

  after_save :destroy_if_order_detail_is_blank, if: Proc.new { |item| item.quantity.zero? }

  def update_tax_adjustments
    additional_tax_total = (price * quantity).floor
  end

  def destroy_if_order_detail_is_blank
    destroy
  end

  def invalid_quantity_check
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def cancel_item(payment)
    begin
      ActiveRecord::Base.transaction do
        other_items = payment.single_order_detail.single_line_items.where.not(id: self.id)
        if other_items.blank? || other_items.except_canceled.blank? #注文自体をキャンセル
          payment.canceled!
        end
        canceled!
        shipment.canceled!
      end
      UserMailer.delay.send_item_canceled_notification(self)
    end
  end

  def prohibit_using_mileage?
    Taxon::FreeShippingId.include?( ProductsTaxon.find_by(product_id: Variant.find(self.variant_id).product_id).taxon_id )
  end

  def can_canceled?
    completed? && variant.available?
  end

  def can_send_back?
    (Date.today - shipment.shipped_at.to_date <= 14) && shipment.shipped?
  end


end
