module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [{ payment_attributes: [:address_id, :credit_card_id] }, :used_point]
  end
end
