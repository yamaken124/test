class Admins::ShipmentsController < Admins::BaseController
  before_filter :set_shipment, only: [:show, :update, :regist_tracking_code]

  def index
    @title = "発送リスト"
    @shipments = Shipment.all.includes(payment: [:payment_method, :user])
  end
  
  def ready
    @title = "未発送リスト"
    @shipments = Shipment.ready.includes(payment: [:payment_method, :user])
    render :action => :index
  end

  def shipped
    @title = "発送済リスト"
    @shipments = Shipment.shipped.includes(payment: [:payment_method, :user])
    render :action => :index
  end

  def canceled
    @title = "キャンセルリスト"
    @shipments = Shipment.canceled.includes(payment: [:payment_method, :user])
    render :action => :index
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
      @shipment.canceled
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
