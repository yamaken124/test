class Users::CheckoutsController < Users::BaseController
  include Users::OrdersHelper

  before_action :load_order_with_lock
  before_action :ensure_valid_state_lock_version, only: [:update]
  before_action :set_state_if_present

  before_action :ensure_order_not_completed
  # before_action :ensure_checkout_allowed
  # before_action :ensure_sufficient_stock_lines
  # before_action :ensure_valid_state

  # before_action :associate_user
  # before_action :check_authorization
  # before_action :apply_coupon_code

  # before_action :setup_for_current_state

  def edit
  end

  private
  def load_order_with_lock
    @order = current_order(lock: true)
    redirect_to cart_path and return unless @order
  end

  def set_state_if_present
    if params[:state]
      redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
  end

  def ensure_order_not_completed
    redirect_to cart_path if @order.completed?
  end
end
