class Admins::Bills::OneClicksController < Admins::BaseController
  def index
    @payments = OneClickPayment.where(payment_method_id: PaymentMethod::CreditCard).includes(user:[:profile]).includes(one_click_detail: [one_click_item: [:variant]]).order("id DESC")
  end

  def show
    @detail = OneClickDetail.find(OneClickPayment.find_by(id: params[:id]).one_click_detail_id)
    @user = @detail.address.user
  end
end
