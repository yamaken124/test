module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:gmo_card_seq_temporary, :payment_method_id] }, :used_point, :address_id,]
  end

  def check_as_default_address(address, default_address)
    address.id == default_address.id ? 'checked: "checked"' : nil
  end
end
