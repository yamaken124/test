class Admins::ShipmentsController < Admins::BaseController
  before_filter :set_shipment, only: [:show, :update, :regist_tracking_code]

  def index
    @shipments = Shipment.all.includes(payment: [:payment_method, :user])
  end

  def show
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

  def regist_tracking_code
    @shipment.tracking = params[:tracking]
    @shipment.save!
    redirect_to admins_shipment_path(@shipment)
  end

  private
   def set_shipment
     @shipment = Shipment.includes(payment: [:user, :address, :single_order_detail => :single_line_items]).find(params[:id])
   end
end
