class Users::TaxonsController < Users::BaseController

  def index
    @taxons = Taxon.where(parent_id: nil)
  end

  def show
    @taxon = Taxon.where(id: params[:id]).first
    @nested_taxons = Taxon.where(parent_id: @taxon.id)
    if @nested_taxons.present?
      @products = Product.none
    else
      @products = Product.where(id: ProductsTaxon.where(taxon_id: @taxon.id).pluck(:product_id))
      .active.having_images_and_variants.where(id: Variant.active.pluck(:product_id)).page(params[:page]).includes(:images)
    end
  end
end
