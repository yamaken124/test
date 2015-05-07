class Users::ProductsController < Users::BaseController

  include Users::OneClickOrdersHelper

  before_action :set_product, only: [:show, :description, :show_one_click]
  before_action :available_quantity, only: [:show, :description, :show_one_click]
  before_action :redirect_to_profile_if_without_any, only: [:post_one_click_order]

  def index
    set_products(Variant.available)

    displayed_variant_ids = Variant.available.ids & Variant.where(product_id: @products.ids).ids
    @single_variants = Variant.where(id: displayed_variant_ids).single_order.includes(:price)
    @subscription_variants = Variant.where(id: displayed_variant_ids).subscription_order.includes(:price)
    # set_prices(displayed_variant_ids)
    top_image(@single_variants)
  end

  def show
    @preview_images = @product.preview_images('top') #to do 共通化
  end

  def show_one_click
    @preview_images = @product.preview_images('top')

    quantity = 1 #default value, would be updated on #update_max_used_point
    @max_used_point = CheckoutValidityChecker.new.unique_variant_max_used_point(current_user, Variant.find(@product.variants.single_order.first), quantity)

    @gmo_cards = GmoMultiPayment::Card.new(current_user).search
    @office_address = current_user.get_business_account['company']
  end

  def post_one_click_order
    if one_click_order_creater
      UserMailer.delay.send_one_click_order_accepted_notification(@detail)
      redirect_to one_click_thanks_orders_path(number: @payment.number)
    else
      if request.referer.present? && ( (params[:error_message] != 'item.none_stock') if params[:error_message].present? )
        redirect_to show_one_click_products_path(id: params[:product_id], error_message: params[:error_message])
      else
        redirect_to products_path
      end
    end
  end

  def description
    @product = Product.find(params[:id])
    redirect_to products_path unless ( @product.available? && @product.displayed?(current_user) && !Taxon::OneClickTaxonIds.include?(@product.taxons.ids.first) )
    @description_images = @product.preview_images('description')
  end

  def update_max_used_point
    updated_max_used_point = CheckoutValidityChecker.new.unique_variant_max_used_point(current_user, Variant.find(params[:variant_id]), params[:quantity])
    render json: updated_max_used_point
  end

  private

    def set_product
      @product = Product.find(params[:id])
      reject_invalid_product
    end

    def set_products(available_variants)
      displayed_product_ids = Product.available.try(:ids) & current_user.shown_product_ids
      @products = Product.where(id: displayed_product_ids).page(params[:page])
    end

    def set_prices(variant_ids)
      single_variants = Variant.where(id: variant_ids).single_order
      @single_prices_indexed_by_variant_id = Price.where(variant_id: single_variants.ids).index_by(&:variant_id)

      subscription_variants = Variant.where(id: variant_ids).subscription_order
      @subscription_prices_indexed_by_variant_id = Price.where(variant_id: subscription_variants.ids).index_by(&:variant_id)
    end

    def top_image(variants)
      @images = Image.where(id: VariantImageWhereabout.top.where(variant_id: variants.ids).pluck(:image_id)).order('position ASC')
    end

    def available_quantity
      @available_quantity = Array(1..Product::AvailableQuantity)
    end

    def reject_invalid_product
      unless ( @product.available? && @product.displayed?(current_user) )
        if request.referer.present?
          redirect_to :back
        else
          redirect_to products_path
        end
      end
    end

    def redirect_to_profile_if_without_any
      if current_user.profile.blank? || current_user.profile.invalid?(:preceed_to_payment)
        redirect_to edit_profile_path(continue: 'show_one_click_products', product_id: params[:product_id])
      end
    end

end
