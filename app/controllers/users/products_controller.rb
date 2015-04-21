class Users::ProductsController < Users::BaseController

  before_action :available_quantity, only: [:show, :description, :show_one_click]

  def index
    set_products(Variant.available)

    displayed_variant_ids = Variant.available.ids & Variant.where(product_id: @products.ids).ids
    @variants_indexed_by_product_id = Variant.where(id: displayed_variant_ids).index_by(&:product_id)

    set_prices(displayed_variant_ids)
    set_images(displayed_variant_ids)
  end

  def show
    @product = Product.find(params[:id])
    redirect_to products_path unless ( @product.available? && @product.displayed?(current_user) )
    @preview_images = @product.preview_images
  end

  def show_one_click
    @product = Product.find(params[:id])
    redirect_to products_path unless ( @product.available? && @product.displayed?(current_user) )
    @preview_images = @product.preview_images

    quantity = 1 #default value, would be updated on #update_max_used_point
    @max_used_point = @product.variants.single_order.first.max_used_point(current_user, quantity)

    @gmo_cards = GmoMultiPayment::Card.new(current_user).search
  end

  def description
    @product = Product.find(params[:id])
  end

  def update_max_used_point
    updated_max_used_point = Variant.find(params[:variant_id]).max_used_point(current_user, params[:quantity])
    render json: updated_max_used_point
  end

  private

    def set_products(available_variants)
      displayed_product_ids = Product.available.ids & current_user.shown_product_ids
      @products = Product.where(id: displayed_product_ids).page(params[:page])
    end

    def set_prices(variant_ids)
      single_variants = Variant.where(id: variant_ids).single_order
      @single_prices_indexed_by_variant_id = Price.where(variant_id: single_variants.ids).index_by(&:variant_id)

      subscription_variants = Variant.where(id: variant_ids).subscription_order
      @subscription_prices_indexed_by_variant_id = Price.where(variant_id: subscription_variants.ids).index_by(&:variant_id)
    end

    def set_images(variant_ids)
      @images = Image.where(imageable_id: variant_ids, imageable_type: 'Variant').index_by(&:imageable_id)
    end

    def available_quantity
      @available_quantity = Array(1..Product::AvailableQuantity)
    end

end
