class CheckoutValidityChecker

  def common_validity_checker(payment_attributes, detail, current_user)
    raise 'payment_attributes_error.used_point_over_limit' if payment_attributes[:used_point].to_i > Payment::UsedPointLimit
    raise 'payment_attributes_error.invalid_used_point' if payment_attributes[:used_point] && !valid_point?(detail, current_user)
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

  def valid_point?(detail, user)
    amount = detail.item_total + detail.additional_tax_total
    (detail.used_point <= user.max_used_point(amount)) && (detail.used_point >= 0)
  end

end