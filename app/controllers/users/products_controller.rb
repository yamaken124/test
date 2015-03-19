class Users::ProductsController < Users::BaseController
  def index
    valid_variant_ids = Variant.valid_variant_ids
    set_products(valid_variant_ids)

    displayed_variants = valid_variant_ids & Variant.where(product_id: @products.pluck(:id)).pluck(:id)
    variants = Variant.where(id: displayed_variants)
    @variants_indexed_by_product_id = variants.index_by(&:product_id)

    set_prices(variants)
    set_images(variants)
  end

  def show
    @product = Product \
      .active \
      .includes(:variants) \
      .includes(:images) \
      .includes(:prices) \
      .where(id: params[:id]).first

    @available_quantity = *(1..@product.available_quantity)

    if @product.blank? || !@product.product_available
      redirect_to products_path
    end
  end

  private
    def set_products(valid_variant_ids)
      @products = Product.active.where(id: Variant.where(id: valid_variant_ids).pluck(:product_id)).page(params[:page])
    end

    def set_prices(variants)
      single_variants = variants.single_order
      @single_prices = Price.where(id: single_variants.ids).index_by(&:variant_id)

      subscription_variants = variants.subscription_order
      @subscription_prices = Price.where(id: subscription_variants.ids).index_by(&:variant_id)
    end

    def set_images(variants)
      @images_indexed_by_variant_id = Image.where(imageable_id: variants.ids).index_by(&:imageable_id) #TODO 両方写真があるとき！！
    end

end