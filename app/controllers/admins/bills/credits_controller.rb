class Admins::Bills::CreditsController < Admins::BaseController
  def index
    @payments = Payment.where(payment_method_id: PaymentMethod::CreditCard).includes(:payment_method).includes(user:[:profile]).order("id DESC")
  end

  def show
    @detail = SingleOrderDetail.find(Payment.find_by(id: params[:id]).single_order_detail_id)
    @user = @detail.address.user
  end
end
