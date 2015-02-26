class Users::OrdersController < Users::BaseController
  respond_to :html
  include Users::OrdersHelper

  before_action :assign_order_with_lock, only: [:update, :remove_item]
  # before_action :apply_coupon_code, only: :update

  def index
  end

  def edit
    @order = current_order || PurchaseOrder.incomplete.new
    associate_user
  end

  def update
    if @order.single_order_contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            #TODO @order.next if @order.cart?
            redirect_to checkout_state_path(state: @order.checkout_steps.first)
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
    SingleLineItem.find(params[:id]).update(quantity: 0)
    update and return
  end

  private

      def order_params
        if params[:order]
          params[:order].permit(*permitted_order_attributes)
        else
          {}
        end
      end

      def assign_order_with_lock
        @order = current_order(lock: true)
        unless @order
          flash[:error] = :order_not_found
          redirect_to cart_path and return
        end
      end

      def permitted_order_attributes
        # { :coupon_code, :email, :shipping_method_id, :special_instructions, :use_billing
          # line_items_attributes: permitted_line_item_attributes }
      end

      def permitted_line_item_attributes
        [:id, :variant_id, :quantity]
      end
end
