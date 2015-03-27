class Admins::ShipmentsController < Admins::BaseController
  before_filter :ensure_valid_state, except: [:return_request]
  before_filter :set_shipment, only: [:show, :update_state, :update_tracking_code]
  before_filter :setup_for_current_state, only: [:index]

  def index
    @title ||= "全発送リスト"
  end

  def show
  end

  def update_state
    @shipment.send("#{params[:state]}!")
    case params[:state]

    when "shipped"
      if @shipment.tracking.present?
        UserMailer.delay.send_items_shipped_notification(@shipment)
      else
        flash[:alert] = "追跡番号を入力してください"
      end
      redirect_to admins_shipment_path(@shipment)

    when "canceled"
      redirect_to admins_shipment_path(@shipment)

    when "returned"
      ReturnedItem.find(params[:returned_item_id]).update(returned_at: Time.now)
      redirect_to return_request_admins_shipments_path
    end
  end

  def update_tracking_code
    @shipment.tracking = params[:tracking]
    @shipment.save!
    redirect_to admins_shipment_path(@shipment)
  end

  def return_request
    @return_requested_items = ReturnedItem.includes(user: [:profile]).includes(single_line_item: [:variant, single_order_detail: [:payment]]).where(returned_at: nil)
  end

  private
    def set_shipment
      @shipment = Shipment.includes(payment: [:user, :address, :single_order_detail => :single_line_items]).find(params[:id])
    end

    def setup_for_current_state
      method_name = :"before_#{params[:state]}"
      send(method_name) if respond_to?(method_name, true)
      @shipments = params[:state] ? Shipment.send(params[:state]).includes(payment: [:payment_method, user: [:profile] ]) : \
        Shipment.all.includes(payment: [:payment_method, user: [:profile] ])
      unless (params[:state] == "ready")
        @shipments = @shipments.order("id DESC")
      end
    end

    def before_ready
      @title = "未発送リスト"
    end

    def before_shipped
      @title = "配送済リスト"
    end

    def before_canceled
      @title = "キャンセルリスト"
    end

    def ensure_valid_state
      raise "Invalid State" if params[:state] && !unknown_state?
    end

    def unknown_state?
      Shipment.transitionable_states.include?(params[:state])
    end
end
