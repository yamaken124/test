module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:gmo_card_seq_temporary, :payment_method_id] }, :used_point, :address_id,]
  end

def check_as_default_address(user, address)
    active_addresses = user.addresses.active
    if active_addresses.pluck(:is_main).none? && address.id == active_addresses.first.id
      'checked: "checked"'
    else
      (address.is_main ? 'checked: "checked"' : nil)
    end
  end
end
