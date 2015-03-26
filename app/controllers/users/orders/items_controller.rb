class Users::Orders::ItemsController < Users::Orders::BaseController

  #single のみになっているので拡張
  def send_back_confirmation
    @item = SingleLineItem.find(params[:item_id])
  end

  def request_send_back
    raise unless current_user.id == SingleLineItem.find(params[:item_id]).single_order_detail.payment.user_id

    ReturnedItem.create(
      single_line_item_id: params[:item_id],
      user_id: current_user.id,
      message: params[:message]
      )
    UserMailer.delay.send_return_request_accepted_notification(SingleLineItem.find(params[:item_id]))

    redirect_to orders_path
  end

end
