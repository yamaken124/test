module Users::OrdersHelper

  private

  def associate_user
    @order ||= current_order
    if try_current_user && @order
      @order.associate_user!(try_current_user) if @order.user.blank?
    end
  end

  def current_order(options = {})
    options[:create_order_if_necessary] ||= false

    return @current_order if @current_order

    @current_order = find_order_by_token_or_user(options, true)

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = PurchaseOrder.new(current_order_params)
      @current_order.user ||= try_current_user
      @current_order.save!

      single_order = @current_order.build_single_order
      single_order.save!
      single_order.build_single_order_detail.save!
    end

    @current_order
  end

  def find_order_by_token_or_user(options={}, with_adjustments = false)
    # Find any incomplete orders for the guest_token
    order = PurchaseOrder.incomplete.find_by(current_order_params)
    # Find any incomplete orders for the current user
    if order.nil? && try_current_user
      order = last_incomplete_order
    end

    order
  end

  def current_order_params
    # { guest_token: cookies.signed[:guest_token], user_id: try_current_user.try(:id) }
    { user_id: try_current_user.try(:id), state: :cart }
  end

  def try_current_user
    # This one will be defined by apps looking to hook into Spree
    # As per authentication_helpers.rb
    if respond_to?(:current_user)
      current_user
    else
      nil
    end
  end

  def last_incomplete_order
    @last_incomplete_order ||= try_current_user.last_incomplete_order
  end

  def set_variants_and_items
    detail = SingleOrderDetail.find(Payment.where(number: @number).pluck(:single_order_detail_id).first)
    @items_indexed_by_variant_id = SingleLineItem.where(single_order_detail_id: detail.id).index_by(&:variant_id)
    @variants = Variant
    .where(id: @items.keys)
    .includes(:images)
    .includes(:prices)
  end

end
