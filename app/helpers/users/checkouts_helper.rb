module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:gmo_card_seq_temporary, :address_id] }, :used_point]
  end
end
