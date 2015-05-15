module Users::ProductsHelper

  private

  def top_products
    set_products

    displayed_variant_ids = Variant.available.ids & Variant.where(product_id: @products.ids).ids
    @single_variants = Variant.where(id: displayed_variant_ids).single_order.includes(:price)
    # @subscription_variants = Variant.where(id: displayed_variant_ids).subscription_order.includes(:price)
    # set_prices(displayed_variant_ids)
    top_image(@single_variants)
  end

  def set_products
    displayed_product_ids = Product.available.try(:ids) & current_user.shown_product_ids
    if @taxon.present?
      selected_product_id = ProductsTaxon.where(taxon_id: @taxon.id).pluck(:product_id)
      @products = Product.where(id: (displayed_product_ids & selected_product_id) ).order('position ASC').page(params[:page])
    else
      @products = Product.where(id: displayed_product_ids).order('position ASC').page(params[:page])
    end
  end

  def set_prices(variant_ids)
    single_variants = Variant.where(id: variant_ids).single_order
    @single_prices_indexed_by_variant_id = Price.where(variant_id: single_variants.ids).index_by(&:variant_id)

    # subscription_variants = Variant.where(id: variant_ids).subscription_order
    # @subscription_prices_indexed_by_variant_id = Price.where(variant_id: subscription_variants.ids).index_by(&:variant_id)
  end

  def top_image(variants)
    @images = Image.where(id: VariantImageWhereabout.top.where(variant_id: variants.ids).pluck(:image_id)).order('position ASC')
  end

end
