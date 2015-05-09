class Admins::Bills::OneClicksController < Admins::BaseController

  include Admins::AuthenticationHelper

  before_action :allow_only_admins

  def index
    @payments = OneClickPayment.where(payment_method_id: PaymentMethod::CreditCard).includes(user:[:profile]).includes(one_click_detail: [one_click_item: [:variant]]).order("id DESC")
  end

  def show
    @detail = OneClickDetail.find(OneClickPayment.find_by(id: params[:id]).one_click_detail_id)
    @user = @detail.one_click_payment.user
    @office_address = current_user.get_business_account['company']
  end
end
