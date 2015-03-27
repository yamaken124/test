class Users::CheckoutsController < Users::BaseController
  include Users::CheckoutsHelper

  before_action :redirect_to_profile_if_without_any, only: [:edit]

  before_action :load_order_with_lock
  before_action :detail
  before_action :set_state_if_present

  before_action :ensure_order_not_completed
  before_action :ensure_checkout_allowed
  before_action :ensure_sufficient_stock_lines
  before_action :ensure_valid_state

  before_action :associate_user
  before_action :check_authorization
  before_action :apply_coupon_code

  before_action :setup_for_current_state

  def edit
  end

  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      if @order.completed?
        @current_order = nil
        flash['order_completed'] = true
        UserMailer.delay.send_order_accepted_notification(@order)
        redirect_to thanks_orders_path(number: @order.single_order_detail.payment.number)
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

  private

    def redirect_to_profile_if_without_any
      if current_user.profile.blank? || current_user.profile.invalid?(:preceed_to_payment)
        redirect_to edit_profile_path(continue: checkout_state_path(state: :payment))
      end
    end

    def load_order_with_lock
      @order = current_order
      redirect_to cart_path and return unless @order
    end

    def detail
      @detail ||= @order.single_order_detail
    end

    def set_state_if_present
      if params[:state]
        redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state])
        @order.state = params[:state]
        set_common_parameter
      end
    end

    def ensure_order_not_completed
      redirect_to cart_path if @order.completed?
    end

    def ensure_checkout_allowed
      unless @order.checkout_allowed?
        redirect_to spree.cart_path
      end
    end

    def ensure_sufficient_stock_lines
      redirect_to cart_path, notice: '商品が選ばれていません' and return if @detail.item_total.zero?
    end

    def ensure_valid_state
      if @order.state != correct_state
        flash.keep
        @order.state = correct_state
        redirect_to checkout_state_path(@order.state)
      end
    end

    def correct_state
      if unknown_state?
        @order.checkout_steps.first
      else
        @order.state
      end
    end

    def unknown_state?
      (params[:state] && !@order.has_checkout_step?(params[:state])) ||
        (!params[:state] && !@order.has_checkout_step?(@order.state))
    end

    def check_authorization
      redirect_to cart_path if current_user.nil? || @order.user_id != current_user.id
    end

    def apply_coupon_code
      # TODO implement
    end

    def setup_for_current_state
      method_name = :"before_#{@order.state}"
      send(method_name) if respond_to?(method_name, true)
    end

    def before_payment
      @gmo_cards = GmoMultiPayment::Card.new(current_user).search
      @addresses = current_user.addresses.active
      @wellness_mileage = current_user.wellness_mileage
    end

    def before_confirm
      @payment = detail.payment
      @address = Address.where(id: @payment.address_id).first
      if @payment.gmo_card_seq_temporary
        gmo_cards = GmoMultiPayment::Card.new(current_user).search
        @gmo_card = gmo_cards[@payment.gmo_card_seq_temporary]
      end
    end

    def set_common_parameter
      @items = Variant
      .where(id: @detail.single_line_items.pluck(:variant_id))
      .includes(:images)
      @single_line_items = @detail.single_line_items
      @tax_rate = TaxRate.rating
    end

end
