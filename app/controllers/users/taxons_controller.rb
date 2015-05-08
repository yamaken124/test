class Users::TaxonsController < Users::BaseController

  include Users::ProductsHelper

  def show
    @taxon = Taxon.find(params[:id])

    @taxon.leaf? ? top_products : @products = Product.none
  end

  private

end
