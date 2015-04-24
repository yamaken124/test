module Users::CheckoutValidityHelper

  def raise_checkout_validity_checker(attributes, detail = {})
    raise_checkout_common_error

    raise 'payment_attributes_error.invalid_used_point' if attributes[:payment_attributes][:used_point] && !valid_point?(detail.used_point)

    items_invalid_checker(single_order_detail)
  end

  def common_validity_checker(detail, attributes)
    raise 'payment_attributes_error.used_point_over_limit' if attributes[:payment_attributes][:used_point].to_i > Payment::UsedPointLimit
    raise 'payment_attributes_error.address_missing' unless has_address_attribtue?(attributes)
    raise 'payment_attributes_error.credit_card_missing' unless has_credit_card_attribtue?(attributes)
    raise 'payment_attributes_error.invalid_used_point' if attributes[:payment_attributes][:used_point] && ( (detail.item_total + detail.additional_tax_total) < detail.used_point )
  end

  def items_invalid_checker(item)
    variant = Variant.find(item.variant_id)
    unless variant.available? && Product.find(variant.product_id).available?
      raise 'item.invalid_item'
    end
  end

  def has_credit_card_attribtue?(attributes)
    attributes[:payment_attributes][:gmo_card_seq_temporary].present?
  end

  def has_address_attribtue?(attributes)
    attributes[:payment_attributes][:address_id].present?
  end

end