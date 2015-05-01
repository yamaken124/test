class Admins::Bills::OneClicksController < Admins::BaseController
  def index
    @payments = OneClickPayment.where(payment_method_id: PaymentMethod::CreditCard).includes(user:[:profile]).includes(one_click_detail: [one_click_item: [:variant]]).order("id DESC")
  end
end
