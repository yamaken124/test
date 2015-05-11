class Admins::Shipments::OneClicksController < Admins::BaseController

  before_filter :set_shipments, only: [:shipment_details]
  before_filter :setup_for_current_state, only: [:index]

  def index
    @title ||= "全発送リスト"
  end

  def shipment_details
    payment_from_shipments(@shipments)
  end

  def update_state
    @shipments = OneClickShipment.where(id: shipment_ids_from_params).includes(one_click_item: [:variant])
    filter_for_update(@shipments)
    method_name = :"update_#{params[:state]}"
    send(method_name, @shipments) if respond_to?(method_name, true)
  end

  def csv_export
    begin
      ActiveRecord::Base.transaction do
        @shipments = OneClickShipment.where(id: params[:shipment_ids].split(' '))
        shipments_update_state(@shipments)
        respond_to do |format|
          format.html do
            @shipments = OneClickShipment.all
          end
          format.csv do
            send_data render_to_string, filename: "lunch.csv", type: :csv
          end
        end
      end
    rescue => e
      params['error_message'] = e.message
    end
  end


  private

    def set_shipments
      @shipments = OneClickShipment.where(id: shipment_ids).includes(one_click_item: [variant: [product: [:taxons]]])
      filter_for_update(@shipments)
    end

    def payment_from_shipments(shipments)
      @payment = OneClickPayment.find_by(one_click_detail_id: shipments.first.one_click_item.one_click_detail_id)
    end

    def filter_for_update(shipments) #FIXME
      redirect_to :back unless ( shipments.present? && has_same_state? && belongs_to_same_taxon? )
    end

    def shipment_ids_from_params
      params[:shipment_ids].split.map(&:to_i)
    end

    def setup_for_current_state
      @shipments = params[:state] ? OneClickShipment.send(params[:state]).includes(one_click_item: [:variant, one_click_detail: [one_click_payment: [user: [:profile] ]]]) : \
        OneClickShipment.all.includes(one_click_item: [:variant ,one_click_detail: [one_click_payment: [user: [:profile] ]]]).order("id DESC")
      method_name = :"before_#{params[:state]}"
      send(method_name) if respond_to?(method_name, true)
    end

    def has_same_state?
      @shipments.all? {|shipment| shipment.state == @shipments.first.state}
    end

    def belongs_to_same_taxon?
      @shipments.all? {|shipment| @shipments.first.one_click_item.variant.product.taxons.ids.include?(shipment.one_click_item.variant.product.taxons.ids.first)}
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
      @title = "発送済リスト"
    end

    def before_canceled
      @shipments = @shipments.order("id DESC")
      @title = "キャンセルリスト"
    end

    def before_exported
      @shipments = @shipments.order("id DESC")
      @title = "csv出力済リスト"
    end

    def unknown_state?
      Shipment.transitionable_states.include?(params[:state])
    end

    def update_shipped(shipments)
      # UserMailer.delay.send_items_shipped_notification(shipments, payment_from_shipments(shipments))
      shipments_update_state(shipments)
      redirect_to :back
    end

    def update_canceled(shipments)
      redirect_to :back and return unless shipments.all? { |shipment| shipment.one_click_item.cancel_item }
      redirect_to :back
    end

    def shipments_update_state(shipments)
      shipments.each do |shipment|
        shipment.send("#{params[:state]}!")
      end
    end

end
