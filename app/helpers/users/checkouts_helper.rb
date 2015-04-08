module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:gmo_card_seq_temporary, :payment_method_id] }, :address_id,]
  end

  def check_as_default_address(address, default_address)
    return nil if address.nil? || default_address.nil?
    address.id == default_address.id ? 'checked: "checked"' : nil
  end
end
