class Admins::Bills::CreditsController < Admins::BaseController
  def index
    @payments = Payment.where(payment_method_id: PaymentMethod::CreditCard).includes(:payment_method).includes(user:[:profile])
  end
end
