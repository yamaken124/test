class Users::ProductsController < Users::BaseController

  before_action :set_tax_rate

  def index
    set_products(Variant.valid_variants)

    displayed_variant_ids = Variant.valid_variants.ids & Variant.where(product_id: @products.pluck(:id)).pluck(:id)
    @variants_indexed_by_product_id = Variant.where(id: displayed_variant_ids).index_by(&:product_id)

    set_prices(displayed_variant_ids)
    set_images(displayed_variant_ids)

  end

  def show
    @product = Product.find(params[:id])

    @available_quantity = *(1..Product::AvailableQuantity)

    @preview_images = @product.preview_images

    if @product.blank? || !@product.available?
      redirect_to products_path
    end
  end

  private
    def set_products(valid_variants)
      @products = Product.active.where(id: Variant.where(id: valid_variants.ids).pluck(:product_id)).page(params[:page])
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

    def set_tax_rate
      @tax_rate = TaxRate.rating
    end

end
