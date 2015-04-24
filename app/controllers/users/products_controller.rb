class Users::ProductsController < Users::BaseController

  include Users::OneClickOrdersHelper
  include Users::ProductsHelper

  before_action :set_product, only: [:show, :description, :show_one_click]
  before_action :available_quantity, only: [:show, :description, :show_one_click]
  before_action :redirect_to_profile_if_without_any, only: [:post_one_click_order]

  def index
    top_products
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
      @products = Product.where(id: displayed_product_ids).order('position ASC').page(params[:page])
    end

    def available_quantity
      max_available_quantity = [Product::AvailableQuantity, @product.variants.single_order.first.stock_quantity].min
      @available_quantity = Array(1..max_available_quantity)
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
