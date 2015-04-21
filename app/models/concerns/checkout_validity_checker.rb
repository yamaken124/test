class CheckoutValidityChecker

  def common_validity_checker(payment_attributes, detail, current_user, items)
    raise 'payment_attributes_error.used_point_over_limit' if payment_attributes[:used_point].to_i > Payment::UsedPointLimit
    raise 'payment_attributes_error.address_missing' unless has_address_attribute?(payment_attributes)
    raise 'payment_attributes_error.credit_card_missing' unless has_credit_card_attribute?(payment_attributes)
  end

  def items_invalid_checker(items)
    items.all? {|item| item_invalid_checker(item) }
  end

  def item_invalid_checker(item)
    variant = Variant.find(item.variant_id)
    unless variant.available? && Product.find(variant.product_id).available?
      raise 'item.invalid_item'
    end
    true
  end

  def has_credit_card_attribute?(payment_attributes)
    payment_attributes[:gmo_card_seq_temporary].present?
  end

  def has_address_attribute?(payment_attributes)
    payment_attributes[:address_id].present?
  end

  def items_valid_point?(user, detail, items)
    amount = detail.item_total + detail.additional_tax_total

    (detail.used_point >= 0) && (detail.used_point <= items_max_used_point(user, items))
  end

  def items_max_used_point(user, items)
    [user.max_used_point, items_upper_used_point(items)].min
  end

  def items_upper_used_point(items)
    items.inject(0) { |sum, item| sum + (Variant.find(item.variant_id).upper_used_point * item.quantity.to_i) }
  end

end