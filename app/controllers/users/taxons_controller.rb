class Users::TaxonsController < Users::BaseController

  def show
    @taxon = Taxon.find(params[:id])
    if @taxon.leaf?
      @products = Product.where(id: ProductsTaxon.where(taxon_id: @taxon.id).pluck(:product_id))
      .active.having_images_and_variants.where(id: Variant.active.pluck(:product_id)).page(params[:page]).includes(:images)
    else
      @products = Product.none
    end
  end
end
