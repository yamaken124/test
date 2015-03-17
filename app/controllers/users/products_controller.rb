class Users::ProductsController < Users::BaseController

  def index
    @products = Product
    .active
    .where(id: set_searched_product_id)
    .page(params[:page])
    .includes(:images)
  end

  def show
    @product = Product \
      .active \
      .includes(:variants) \
      .includes(:images) \
      .includes(:prices) \
      .where(id: params[:id]).first

    if @product.blank? || !@product.product_available
      redirect_to products_path
    end
  end

  private

    def set_searched_product_id
      searched_id = Product.active.having_images_and_variants.pluck(:id) && Variant.active.pluck(:product_id)
      if params[:taxon].present?
        searched_id && ProductsTaxon.where(taxon_id: params[:taxon]).pluck(:product_id)
      else
        searched_id
      end
    end

end