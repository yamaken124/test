module Users::OneClickOrdersHelper

  private

  def one_click_order_creater

    detail = OneClickDetail.create!(detail_attributes)
    # todo nested attributes
    item = OneClickItem.create!(item_attributes(detail))
    CheckoutValidityChecker.new.common_validity_checker(payment_attributes(detail), detail, current_user)
    @payment = OneClickPayment.new(payment_attributes(detail))

    raise 'gmo_transaction_failed' unless @payment.pay_with_gmo_payment
    @payment.save!

  end

  def detail_attributes
    one_click_order_updater.merge(
      tax_rate_id: 1,
      completed_on: Date.today,
      completed_at: Time.now,
      address_id: current_user.addresses.last.id, #TODO company_address or null
      used_point: used_point,
      item_count: order_attributes_from_params[:item_count],
      )

  end

  def payment_attributes(detail)
    payment_attributes_from_params.merge(
      amount: detail.paid_total,
      used_point: used_point,
      payment_method_id: 1,
      address_id: current_user.addresses.last.id,
      number: one_click_number(detail),
      user_id: current_user.id,
      gmo_card_seq_temporary: payment_attributes_from_params[:gmo_card_seq_temporary],#FIXME
      one_click_detail_id: detail.id,
      )
  end

  def item_attributes(detail)
    item_attributes_from_params.merge(
      one_click_detail_id: detail.id,
      quantity: order_attributes_from_params[:item_count],
      price: Variant.find(item_attributes_from_params[:variant_id]).price.amount,
      )
  end

  def one_click_order_updater
    # FIXME order_updaterと統合
    order = {}
    order[:item_total] = item_total
    order[:total] = order[:item_total]
    order[:paid_total] = order[:total] - used_point.to_i
    order[:included_tax_total] = order[:paid_total] - ( order[:paid_total] / (TaxRate.rating) ).floor
    order

  end

  def item_total
    Variant.find(item_attributes_from_params[:variant_id]).price.amount.to_i * order_attributes_from_params[:item_count].to_i
  end

  def order_attributes_from_params
    params.require(:order).permit(:use_all_point, :used_point, :item_count)
  end

  def payment_attributes_from_params
    params[:order].require(:payment_attributes).permit(:gmo_card_seq_temporary, :payment_method_id)
  end

  def item_attributes_from_params
    params[:order].require(:item_attributes).permit(:variant_id)
  end

  def one_click_number(detail)
    number = "o" + Time.now.to_i.to_s + detail.one_click_item.id.to_s
  end

  def used_point
    if order_attributes_from_params[:use_all_point] == "true"
      current_user.max_used_point(item_total)
    else
      order_attributes_from_params[:used_point]
    end
  end

end