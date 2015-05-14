class OrderUpdater
  attr_reader :order, :order_detail
  delegate :total, :item_total, :shipment_total, :adjustment_total, :used_point, :payment, to: :order_detail

  def initialize(order_detail)
    @order        = order_detail.single_order
    @order_detail = order_detail
  end

  def update
    update_totals
    if order.purchase_order.completed? && order_detail.single_line_items.canceled_items.blank?
      update_payment_state
    end
    persist_totals
  end

  def update_totals
    update_item_total
    update_item_count
    update_shipment_total
    update_used_point
    update_adjustment_total
    update_included_tax_total
  end

  def update_item_total
    order_detail.item_total = order_detail.single_line_items.except_canceled.sum('price * quantity')
    update_order_total
  end

  def update_shipment_total
    # order_detail.shipment_total = shipments.sum(:cost)
    order_detail.shipment_total = (item_total >= 10_000) ? 0 : 500
    update_order_total
  end

  def update_used_point
    return if payment.nil? || !payment.completed?
    if order_detail.item_total > payment.used_point
      order_detail.used_point = payment.used_point
    else #キャンセル対応
      order_detail.used_point = order_detail.item_total
      # point return
      user = User.find_by(id: order_detail.payment.user_id)
      user.update_used_point_total( order_detail.item_total - payment.used_point )
    end
  end

  def update_adjustment_total
    update_order_total
  end

  def update_included_tax_total
    paid_money = order_detail.total - order_detail.shipment_total
    order_detail.included_tax_total = paid_money - ( paid_money / (TaxRate.rating) ).floor
  end

  def update_order_total
    order_detail.total = item_total + shipment_total + adjustment_total - used_point
  end

  def update_item_count
    order_detail.item_count = order_detail.single_line_items.except_canceled.sum(:quantity)
  end

  def persist_totals
    if order_detail.single_line_items.canceled_items.blank? #使ってないのでは
      order_detail.update(
        item_total: order_detail.item_total,
        item_count: order_detail.item_count,
        adjustment_total: order_detail.adjustment_total,
        additional_tax_total: order_detail.additional_tax_total,
        shipment_total: order_detail.shipment_total,
        included_tax_total: order_detail.included_tax_total,
        total: order_detail.total,
        paid_total: order_detail.total,
      )
    else
      SingleOrderDetail.find(order_detail.id).update(
        item_total: order_detail.item_total,
        item_count: order_detail.item_count,
        adjustment_total: order_detail.adjustment_total,
        additional_tax_total: order_detail.additional_tax_total,
        shipment_total: order_detail.shipment_total,
        included_tax_total: order_detail.included_tax_total,
        total: order_detail.total,
        paid_total: order_detail.total,
        order_changed_at: Time.now,
        used_point: order_detail.used_point,
      )
    end
  end

  def update_payment_state
    last_state = order.payment_state
    if payments.present? && payments.valid.size == 0
      order.payment_state = 'failed'
    elsif order.state == 'canceled' && order.payment_total == 0
      order.payment_state = 'void'
    else
      order.payment_state = 'balance_due' if order.outstanding_balance > 0
      order.payment_state = 'credit_owed' if order.outstanding_balance < 0
      order.payment_state = 'paid' if !order.outstanding_balance?
    end
    order.state_changed('payment') if last_state != order.payment_state
    order.payment_state
  end

  private
  def round_money(n)
    (n * 100).round / 100.0
  end
end
