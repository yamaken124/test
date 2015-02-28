class OrderUpdater
  attr_reader :order, :order_detail
  delegate :total, :item_total, :shipment_total, :adjustment_total, :used_point, :payment, to: :order_detail

  def initialize(order_detail)
    @order        = order_detail.single_order
    @order_detail = order_detail
  end

  # This is a multi-purpose method for processing logic related to changes in the Order.
  # It is meant to be called from various observers so that the Order is aware of changes
  # that affect totals and other values stored in the Order.
  #
  # This method should never do anything to the Order that results in a save call on the
  # object with callbacks (otherwise you will end up in an infinite recursion as the
  # associations try to save and then in turn try to call +update!+ again.)
  def update
    update_totals
    if order.purchase_order.completed?
      update_payment_state
      update_shipments
      update_shipment_state
    end
    run_hooks
    persist_totals
  end

  def run_hooks
    # update_hooks.each { |hook| order.send hook }
  end

  def recalculate_adjustments
    order_detail.single_line_items.includes(:tax_rate).each do |item|
      item.update_tax_adjustments
    end
    order_detail.update_tax_adjustments
  end

  # Updates the following Order total values:
  #
  # +payment_total+      The total value of all finalized Payments (NOTE: non-finalized Payments are excluded)
  # +item_total+         The total value of all LineItems
  # +adjustment_total+   The total value of all adjustments (promotions, credits, etc.)
  # +promo_total+        The total value of all promotion adjustments
  # +total+              The so-called "order total."  This is equivalent to +item_total+ plus +adjustment_total+.
  def update_totals
    update_payment_total
    update_item_total
    update_shipment_total
    update_used_point
    update_adjustment_total
  end


  # give each of the shipments a chance to update themselves
  def update_shipments
    # shipments.each do |shipment|
      # next unless shipment.persisted?
      # shipment.update!(order)
      # shipment.refresh_rates
      # shipment.update_amounts
    # end
  end

  # paymentの最終金額(支払額 - 返金額)を保存しておきたい場合に利用
  def update_payment_total
    # order_detail.payment_total = payments.completed.includes(:refunds).inject(0) { |sum, payment| sum + payment.amount - payment.refunds.sum(:amount) }
    # order_detail.total = payments.completed.includes(:refunds).inject(0) { |sum, payment| sum + payment.amount - payment.refunds.sum(:amount) }
  end

  def update_shipment_total
    # order_detail.shipment_total = shipments.sum(:cost)
    order_detail.shipment_total = (item_total >= 10_000) ? 0 : 700
    update_order_total
  end

  def update_used_point
    detail.used_point = payment.used_point if payment
  end

  def update_order_total
    total = item_total + shipment_total + adjustment_total - used_point
  end

  def update_adjustment_total
    # single_line_itemsとsingle_order_detailsの税金の再計算だけ行えば良い。
    # shipmentをテーブルで扱うときはshipmentの税金の再計算も行う
    recalculate_adjustments

    update_order_total
  end

  def update_item_count
    order_detail.item_count = order_detail.single_line_items.sum(:quantity)
  end

  def update_item_total
    order_detail.item_total = order_detail.single_line_items.sum('price * quantity')
    update_order_total
  end

  def persist_totals
    order_detail.update(
      item_total: order_detail.item_total,
      item_count: order_detail.item_count,
      adjustment_total: order_detail.adjustment_total,
      additional_tax_total: order_detail.additional_tax_total,
      shipment_total: order_detail.shipment_total,
      total: order_detail.total,
      updated_at: Time.now
    )
  end

  # Updates the +shipment_state+ attribute according to the following logic:
  #
  # shipped   when all Shipments are in the "shipped" state
  # partial   when at least one Shipment has a state of "shipped" and there is another Shipment with a state other than "shipped"
  #           or there are InventoryUnits associated with the order that have a state of "sold" but are not associated with a Shipment.
  # ready     when all Shipments are in the "ready" state
  # backorder when there is backordered inventory associated with an order
  # pending   when all Shipments are in the "pending" state
  #
  # The +shipment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
  def update_shipment_state
    # if order.backordered?
      # order.shipment_state = 'backorder'
    # else
      # # get all the shipment states for this order
      # shipment_states = shipments.states
      # if shipment_states.size > 1
        # # multiple shiment states means it's most likely partially shipped
        # order.shipment_state = 'partial'
      # else
        # # will return nil if no shipments are found
        # order.shipment_state = shipment_states.first
        # # TODO inventory unit states?
        # # if order.shipment_state && order.inventory_units.where(:shipment_id => nil).exists?
        # #   shipments exist but there are unassigned inventory units
        # #   order.shipment_state = 'partial'
        # # end
      # end
    # end

    # order.state_changed('shipment')
    # order.shipment_state
  end

  # Updates the +payment_state+ attribute according to the following logic:
  #
  # paid          when +payment_total+ is equal to +total+
  # balance_due   when +payment_total+ is less than +total+
  # credit_owed   when +payment_total+ is greater than +total+
  # failed        when most recent payment is in the failed state
  #
  # The +payment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
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
