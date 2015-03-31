class Admins::ShipmentsController < Admins::BaseController
  before_filter :ensure_valid_state, except: [:return_requests]
  before_filter :set_shipment, only: [:show, :update_state, :update_tracking_code]
  before_filter :setup_for_current_state, only: [:index]

  def index
    @title ||= "全発送リスト"
  end

  def show
  end

  def update_state
    case params[:state]

    when "shipped"
      if @shipment.tracking.present?
        UserMailer.delay.send_items_shipped_notification(@shipment)
        @shipment.send("#{params[:state]}!")
      else
        flash[:alert] = "追跡番号を入力してください"
      end
      redirect_to admins_shipment_path(@shipment)

    when "canceled"
      item = SingleLineItem.find(params[:single_line_item_id])
      item.cancel_item(item.single_order_detail.payment)
      redirect_to admins_shipment_path(@shipment)

    when "returned"
      ReturnedItem.find(params[:returned_item_id]).update(returned_at: Time.now)
      @shipment.send("#{params[:state]}!")
      redirect_to return_requests_admins_shipments_path
    end
  end

  def update_tracking_code
    @shipment.tracking = params[:tracking]
    @shipment.save!
    redirect_to admins_shipment_path(@shipment)
  end

  def return_requests
    @return_requested_items = ReturnedItem.includes(user: [:profile]).includes(single_line_item: [:variant, single_order_detail: [:payment]]).where(returned_at: nil)
    @title = "返品要望リスト"
  end

  private
    def set_shipment
      @shipment = Shipment.includes(payment: [:user, :address, single_order_detail: [ single_line_items: [ variant: [:images ] ] ] ]).find(params[:id])
    end

    def setup_for_current_state
      @shipments = params[:state] ? Shipment.send(params[:state]).includes(payment: [:payment_method, user: [:profile] ]) : \
        Shipment.all.includes(payment: [:payment_method, user: [:profile] ]).order("id DESC")
      method_name = :"before_#{params[:state]}"
      send(method_name) if respond_to?(method_name, true)
    end

    def before_ready
      @title = "未発送リスト"
    end

    def before_shipped
      @shipments = @shipments.order("id DESC")
      @title = "配送済リスト"
    end

    def before_canceled
      @shipments = @shipments.order("id DESC")
      @title = "キャンセルリスト"
    end

    def ensure_valid_state
      raise "Invalid State" if params[:state] && !unknown_state?
    end

    def unknown_state?
      Shipment.transitionable_states.include?(params[:state])
    end

end
