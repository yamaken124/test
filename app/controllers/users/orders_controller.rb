class Users::OrdersController < Users::BaseController
  include Users::OrdersHelper

  before_action :assign_order_with_lock, only: :update
  before_action :apply_coupon_code, only: :update

  def index
  end

  def edit
    @order = current_order || PurchaseOrder.incomplete.new
    associate_user
  end

  def update
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    populator = OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], params[:quantity], params[:options])
      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(spree.root_path)
    end
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
          flash[:error] = Spree.t(:order_not_found)
          redirect_to root_path and return
        end
      end

      def permitted_order_attributes
        { :coupon_code, :email, :shipping_method_id, :special_instructions, :use_billing
          line_items_attributes: permitted_line_item_attributes }
      end

      def permitted_line_item_attributes
        [:id, :variant_id, :quantity]
      end
end
