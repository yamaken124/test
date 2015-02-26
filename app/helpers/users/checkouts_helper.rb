module Users::CheckoutsHelper
  def permitted_checkout_attributes
    [:address_id, :used_point, :payment_method_id]
  end
end
