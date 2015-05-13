class CheckoutValidityChecker

  def common_validity_checker(payment_attributes, detail, current_user, items)
    @items = items
    @user = current_user
    @payment_attributes = payment_attributes
    # raise error if items are unavailable, like out of stock, inactive
    items_invalid_checker
    # raise error in case address missing unless it is one_click_order
    raise 'payment_attributes_error.address_missing' unless has_address_attribute?
    # raise error in case credit_card missing
    raise '@payment_attributes_error.credit_card_missing' unless has_credit_card_attribute?
    # raise error in case used_point is over limit
    items_valid_point_checker(detail)
  end

  def items_invalid_checker
    return item_invalid_checker(@items) if @items.instance_of?(OneClickItem)
    @items.all? {|item| item_invalid_checker(item) }
  end

  def item_invalid_checker(item)
    unless item.variant.available?
      raise 'item.invalid_item' unless out_of_stock_item?(item)
    end
  end

  def out_of_stock_item?(item)
    stock_quantity = item.variant.stock_quantity
    if stock_quantity <= 0
      remove_none_stock_item
      raise 'item.none_stock'
    elsif item.quantity > stock_quantity
      # update from cart
      raise 'item.over_stock'
    else
      false
    end
  end

  def remove_none_stock_item
# remove from cart
  end

  def update_over_stock_item
# remove from cart
  end

  def has_address_attribute?
    return true if @items.instance_of?(OneClickItem)
    @payment_attributes[:address_id].present?
  end

  def has_credit_card_attribute?
    @payment_attributes[:gmo_card_seq_temporary].present?
  end

  def items_valid_point_checker(detail)
    if detail.used_point < 0
      raise 'payment_attributes_error.minus_used_point'
    elsif detail.used_point > items_max_used_point(@user, @items)
      (detail.used_point > Payment::UsedPointLimit) ? (raise 'payment_attributes_error.over_used_point_limit') : (raise 'payment_attributes_error.invalid_used_point')
    end
  end

  def items_max_used_point(user, items) # also refered by product one_click action
    [user.max_used_point, Payment::UsedPointLimit, items_upper_used_point(items)].min
  end

  def unique_variant_max_used_point(user, variant, quantity)
    [user.max_used_point, Payment::UsedPointLimit, (variant.upper_used_point * quantity.to_i)].min
  end

  def items_upper_used_point(items)
    if items.instance_of?(OneClickItem)
      Variant.find(items.variant_id).upper_used_point * items.quantity.to_i
    else
      items.inject(0) { |sum, item| sum + (Variant.find(item.variant_id).upper_used_point * item.quantity.to_i) }
    end
  end

end