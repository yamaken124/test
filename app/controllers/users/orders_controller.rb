class Users::OrdersController < Users::BaseController
  respond_to :html
  include Users::OrdersHelper

  before_action :assign_order_with_lock, only: [:edit, :update, :remove_item]
  before_action :set_variants, only: [:edit]
  before_action :set_number, only: [:thanks, :one_click_thanks]
  # before_action :apply_coupon_code, only: :update

  def single_history
    single_order_detail_id = Payment.where(user_id: current_user.id).pluck(:single_order_detail_id)
    @details = SingleOrderDetail.where(id: single_order_detail_id).includes(:payment, single_line_items: :shipment).includes(single_line_items:[variant: [:price, :images]]).order(completed_at: :desc).page(params[:page])
    variant_ids = SingleLineItem.where(single_order_detail_id: @details.pluck(:id)).pluck(:variant_id)
    @returned_item_indexed_by_item_id = ReturnedItem.where(user_id: current_user.id).index_by(&:single_line_item_id)
  end

  def one_click_history
    one_click_detail_id = OneClickPayment.where(user_id: current_user.id).pluck(:one_click_detail_id)
    @details = OneClickDetail.where(id: one_click_detail_id).includes(:one_click_payment, one_click_item: [:one_click_shipment, variant: [:price]]).order(completed_at: :desc).page(params[:page])
  end

  def thanks
    @payment = Payment.find_by(number: @number)
    raise ActiveRecord::RecordNotFound if !@payment.completed?
    @items = @payment.single_order_detail.single_line_items.includes(variant: [:images, :price])
  end

  def one_click_thanks
    @payment = OneClickPayment.find_by(number: @number)
    @item = @payment.one_click_detail.one_click_item
    render :thanks
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

  def cancel
    payment = Payment.find_by(user_id: current_user.id, number: params[:number])
    item = payment.single_order_detail.single_line_items.find_by(id: params[:item_id])
    item.cancel_item(payment)
    redirect_to single_history_orders_path
  end

  def one_click_cancel
    payment = OneClickPayment.find_by(user_id: current_user.id, number: params[:number])
    item = payment.one_click_detail.one_click_item
    item.cancel_item
    redirect_to one_click_history_orders_path
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
    end

    def set_number
      @number = params[:number]
    end

end
