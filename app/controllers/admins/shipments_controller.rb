class Admins::ShipmentsController < Admins::BaseController
  before_filter :ensure_valid_state
  before_filter :set_shipment, only: [:show, :update, :regist_tracking_code]
  before_filter :set_title, only: [:index]
  before_filter :set_shipments, only: [:index]

  def index
  end 

  def show
  end

  def update
    @shipment.send("#{params[:state]}!")
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

    def set_title
      @title = params[:state] ? "ステータス : #{params[:state]}" : "全発送リスト一覧"
    end

    def set_shipments 
      @shipments = params[:state] ? Shipment.send(params[:state]).includes(payment: [:payment_method, :user]) : Shipment.all.includes(payment: [:payment_method, :user])
    end

    def ensure_valid_state
      raise "Invalid State" if params[:state] && !unknown_state?
    end

    def unknown_state?
      Shipment.states.keys.include?(params[:state])
    end
end
