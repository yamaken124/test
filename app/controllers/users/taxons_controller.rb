class Users::TaxonsController < Users::BaseController

  def show
    @taxon = Taxon.find(params[:id])
    if @taxon.leaf?
      set_products(Variant.available_variants)

      displayed_variant_ids = Variant.available_variants.ids & Variant.where(product_id: @products.pluck(:id)).pluck(:id)
      @variants_indexed_by_product_id = Variant.where(id: displayed_variant_ids).index_by(&:product_id)

      set_prices(displayed_variant_ids)
      set_images(displayed_variant_ids)

    else
      @products = Product.none
    end

  end

  private

    def set_products(available_variants)
      selected_product_id = ProductsTaxon.where(taxon_id: @taxon.id).pluck(:product_id) & Variant.where(id: Variant.available_variants.ids).pluck(:product_id)
      @products = Product.active.where(id: selected_product_id).page(params[:page])
    end

    def set_prices(variant_ids)
      single_variants = Variant.where(id: variant_ids).single_order
      @single_prices_indexed_by_variant_id = Price.where(variant_id: single_variants.ids).index_by(&:variant_id)

      subscription_variants = Variant.where(id: variant_ids).subscription_order
      @subscription_prices_indexed_by_variant_id = Price.where(variant_id: subscription_variants.ids).index_by(&:variant_id)
    end

    def set_images(variant_ids)
      @images = Image.where(imageable_id: variant_ids, imageable_type: 'Variant').index_by(&:imageable_id) #TODO 両方写真があるとき！！
    end

end
