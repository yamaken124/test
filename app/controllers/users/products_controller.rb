class Users::ProductsController < Users::BaseController
  def index
    valid_variant_ids = Variant.valid_variant_ids
    set_products(valid_variant_ids)

    displayed_variants_id = valid_variant_ids & Variant.where(product_id: @products.pluck(:id)).pluck(:id)
    variants_records = Variant.where(id: displayed_variants_id)
    @variants = variants_records.index_by(&:product_id)

    set_prices(variants_records)
    set_images(variants_records)
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
      @images = Image.where(imageable_id: variants.ids).index_by(&:imageable_id) #TODO 両方写真があるとき！！
    end

end