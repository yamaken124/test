class Users::CheckoutsController < Users::BaseController
  include Users::OrdersHelper
  include Users::CheckoutsHelper

  before_action :load_order_with_lock
  before_action :ensure_valid_state_lock_version, only: [:update]
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
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

  private

    def load_order_with_lock
      @order = current_order
      redirect_to cart_path and return unless @order
    end

    def ensure_valid_state_lock_version
      if params[:order] && params[:order][:state_lock_version]
        @order.with_lock do
          unless @order.lock_version == params[:order].delete(:lock_version).to_i
            flash[:error] = Spree.t(:order_already_updated)
            redirect_to checkout_state_path(@order.state) and return
          end
          @order.increment!(:lock_version)
        end
      end
    end

    def set_state_if_present
      if params[:state]
        redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state])
        @order.state = params[:state]
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
      # TODO implement
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
end
