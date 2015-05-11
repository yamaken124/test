class Admins::Shipments::SinglesController < Admins::BaseController

  before_filter :set_shipments, only: [:shipment_details]
  before_filter :setup_for_current_state, only: [:index]

  def index
    @title ||= "全発送リスト"
  end

  def shipment_details
    payment_from_shipments(@shipments)
    set_tracking(@shipments)
  end

  def update_state
    @shipments = Shipment.where(id: shipment_ids_from_params).includes(single_line_item: [:variant])
    filter_for_update(@shipments)
    method_name = :"update_#{params[:state]}"
    send(method_name, @shipments) if respond_to?(method_name, true)
  end

  def update_tracking_code
    shipment_ids_from_params.each do |shipment_id|
      Shipment.find(shipment_id).update(tracking: params[:tracking])
    end
    redirect_to :back
  end

  def return_requests
    @return_requested_items = ReturnedItem.includes(user: [:profile]).includes(single_line_item: [:shipment, variant: [:product], single_order_detail: [:payment]]).where(returned_at: nil)
    @title = "返品要望リスト"
  end

  private
    def set_shipments
      @shipments = Shipment.where(id: shipment_ids).includes(single_line_item: [:variant] )
      filter_for_update
    end

    def payment_from_shipments(shipments)
      @payment = Payment.find_by(single_order_detail_id: shipments.first.single_line_item.single_order_detail_id)
    end

    def filter_for_update
      redirect_to :back and return unless (has_same_state? && @shipments.present? && ordered_by_same_user?)
    end

    def ordered_by_same_user?
      @shipments.all? {|shipment| shipment.address.user == @shipments.first.address.user}
    end

    def has_same_state?
      @shipments.all? {|shipment| shipment.state == @shipments.first.state}
    end

    def shipment_ids_from_params
      params[:shipment_ids].split.map(&:to_i)
    end

    def set_tracking(shipments)
      if has_same_tracking?(shipments)
        @tracking = shipments.first.tracking
      end
      @button_value = @tracking.present? ? "変更" : "登録"
    end

    def setup_for_current_state
      @shipments = params[:state] ? Shipment.send(params[:state]).includes(single_line_item: [:variant, single_order_detail: [payment: [user: [:profile] ]]]) : \
        Shipment.all.includes(single_line_item: [:variant, single_order_detail: [payment: [user: [:profile] ]]]).order("id DESC")
      method_name = :"before_#{params[:state]}"
      send(method_name) if respond_to?(method_name, true)
    end

    def has_same_tracking?(shipments)
      shipments.first.tracking.present? && (shipments.all? {|shipment| shipment.tracking == shipments.first.tracking})
    end

    def shipment_ids
      return nil if params[:shipment].nil?
      shipment_ids = params[:shipment].require(:ids)
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

    def unknown_state?
      Shipment.transitionable_states.include?(params[:state])
    end

    def update_shipped(shipments)
      redirect_to :back and return unless has_same_tracking?(shipments)
      UserMailer.delay.send_items_shipped_notification(shipments, payment_from_shipments(shipments))
      shipments_update_state(shipments)
      redirect_to :back
    end

    def update_canceled(shipments)
      # 現在キャンセルは商品一つずつのみ対応
      shipments.first.single_line_item.cancel_item(payment_from_shipments(shipments))
      redirect_to admins_shipments_singles_path
    end

    def update_returned(shipments)
      ReturnedItem.find(params[:returned_item_id]).update(returned_at: Time.now)
      redirect_to :back
    end

    def shipments_update_state(shipments)
      shipments.each do |shipment|
        shipment.send("#{params[:state]}!")
      end
    end

end
