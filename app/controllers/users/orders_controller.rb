class Users::OrdersController < Users::BaseController
  respond_to :html
  include Users::OrdersHelper

  before_action :assign_order_with_lock, only: [:edit, :update, :remove_item]
  before_action :set_variants, only: [:edit]
  # before_action :apply_coupon_code, only: :update

  def index
    single_order_detail_id = Payment.where(user_id: current_user.id).pluck(:single_order_detail_id)
    @details = SingleOrderDetail.where(id: single_order_detail_id).includes(:address, payment: :shipment).includes(:single_line_items).order(completed_at: :desc)
    variant_ids = SingleLineItem.where(single_order_detail_id: @details.pluck(:id)).pluck(:variant_id)
    @variants_indexed_by_id = Variant.where(id: variant_ids).includes(:images, :price).index_by(&:id)
  end

  def thanks
    @number = params[:number]
    raise ActiveRecord::RecordNotFound if !Payment.where(number: @number).first.completed?
    set_variants_and_items
  end

  def edit
    associate_user
  end

  def update
    if @order.single_order_contents.update_cart(order_params) #TODO order_params
      respond_with(@order) do |format|
        format.html do
          if params["checkout"]
            redirect_to checkout_state_path(state: @order.checkout_steps.first)\
          else
            redirect_to cart_path
          end
        end
      end
    else
      redirect_to cart_path
    end
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = (params[:options] || {})#.merge(currency: current_currency)

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.single_order_contents.add(variant, quantity, options)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = :please_enter_reasonable_quantity
    end
    if error
      flash[:error] = error
      redirect_to products_path
    else
      respond_with(order) do |format|
        format.html { redirect_to cart_path }
      end
    end
  end

  def remove_item
    remove_params = order_params.merge({ single_line_items_attributes: [{id: params[:id], quantity: 0 }]})
    if @order.single_order_contents.update_cart(remove_params)
      respond_with(@order) do |format|
        format.html do
          redirect_to cart_path
        end
      end
    else
      redirect_to cart_path
    end
  end

  def update_item  # TODO switch to order_params
    param = params[:purchase_order][:single_order_attributes][:single_order_detail_attributes][:single_line_items_attributes]
    0.upto(param.length-1){|p|
      num=p.to_s
      SingleLineItem.find(param[p.to_s]["id"]).update(quantity: param[p.to_s]["quantity"])
    }
    params["updated_quantity"] = nil
  end

  #single のみになっているので拡張
  def sent_back
    @detail = SingleOrderDetail.where(id: Payment.where(number: params[:number]).first.single_order_detail_id).first
  end

  def sent_back_report
    #TODO send mail
    redirect_to orders_path
  end

  def cancel
    detail = SingleOrderDetail.where(id: Payment.where(number: params[:number]).first.single_order_detail_id).first
    begin
      ActiveRecord::Base.transaction do
        detail.payment.shipment.canceled!
        detail.payment.canceled!
      end
    end
    redirect_to :back
  end

  private

    def order_params
      if params[:purchase_order]
        params[:purchase_order].permit(*permitted_order_attributes)
      else
        {}
      end
    end

    def assign_order_with_lock
      @order = current_order({lock: true, create_order_if_necessary: true})
      unless @order
        flash[:error] = :order_not_found
        redirect_to cart_path and return
      end
    end

    def permitted_order_attributes
      [ single_line_items_attributes: permitted_line_item_attributes ]
    end

    def permitted_line_item_attributes
      [:id, :variant_id, :quantity]
    end

    def set_variants
      @variants = @order.variants
      .includes(:images)
    end

end
