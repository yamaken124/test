class SingleOrderContents
  delegate :single_order, to: :order
  attr_accessor :order, :detail

  def initialize(order)
    @order = order.single_order || order.build_single_order
  end

  def add(variant, quantity = 1, options = {})
    line_item = add_to_line_item(variant, quantity, options)
    after_add_or_remove(line_item, options)
  end

  def remove(variant, quantity = 1, options = {})
    line_item = remove_from_line_item(variant, quantity, options)
    after_add_or_remove(line_item, options)
  end

  def update_cart(params)
    if detail.update(params)
      detail.single_line_items = detail.single_line_items.select { |li| li.quantity > 0 }
      # Update totals, then check if the order is eligible for any cart promotions.
      # If we do not update first, then the item total will be wrong and ItemTotal
      # promotion rules would not be triggered.
      reload_totals
      detail.ensure_updated_shipments
      reload_totals
      true
    else
      false
    end
  end

  def detail
    return @detail if @detail

    single_order_detail = order.single_order_detail || order.build_single_order_detail
    @detail ||= single_order_detail
  end

  private
  def after_add_or_remove(line_item, options = {})
    reload_totals
    line_item
  end

  def order_updater
    @updater ||= OrderUpdater.new(detail)
  end

  def reload_totals
    order_updater.update_item_count
    order_updater.update
    order.reload
  end

  def add_to_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, false, options)

    if line_item
      line_item.quantity += quantity.to_i
    else
      line_item = detail.single_line_items.new(quantity: quantity,
                                               variant: variant,
                                               price: variant.price.amount)
    end
    line_item.target_shipment = options[:shipment] if options.has_key? :shipment
    line_item.save!
    line_item
  end

  def remove_from_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, true, options)
    line_item.quantity -= quantity
    line_item.target_shipment= options[:shipment]

    if line_item.quantity == 0
      line_item.destroy
    else
      line_item.save!
    end

    line_item
  end

  def grab_line_item_by_variant(variant, raise_error = false, options = {})
    line_item = order.find_line_item_by_variant(variant, options)

    if !line_item.present? && raise_error
      raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
    end

    line_item
  end
end
