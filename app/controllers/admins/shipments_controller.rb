class Admins::ShipmentsController < Admins::BaseController
  before_filter :set_shipment, only: [:show, :update]

  def index
    @shipments = Shipment.all.includes(payment: [:payment_method, :user])
  end

  def show
    @single_line_items = SingleLineItem.where(single_order_detail_id: @shipment.payment.single_order_detail_id).includes(:variant)
    @address = Address.find(@shipment.payment.address_id)
    @single_order_detail = SingleOrderDetail.find(@shipment.payment.single_order_detail_id)
    @purchase_user = User.find(@shipment.payment.user_id)
  end

  def update
    case params[:state].to_sym
    when :ready
      @shipment.ready
    when :shipped
      @shipment.shipped
    when :canceled
      @shipment.calceled
    end
    @shipment.save!
    redirect_to admins_shipment_path(@shipment)
  end

  private
   def set_shipment
     @shipment = Shipment.find(params[:id])
   end
end
