module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:address_id, :gmo_card_seq_temporary] }, :used_point]
  end
end
