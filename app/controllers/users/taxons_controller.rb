class Users::TaxonsController < Users::BaseController
  def show
    @taxon = Taxon.where(name: params[:id]).first
    @nested_taxons = Taxon.where(parent_id: @taxon.id)
    if @nested_taxons.present? 
      @products = Product.none
    else
      @products = Product.where(id: ProductsTaxon.where(taxon_id: @taxon.id).pluck(:product_id))
    end
  end
end
