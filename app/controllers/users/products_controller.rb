class Users::ProductsController < Users::BaseController
  def index
    @products = Product \
      .active \
      .having_images_and_variants \
      .where(id: Variant.active.pluck(:product_id)) \
      .page(params[:page]) \
      .includes(:images)
  end

  def show
    @product = Product \
      .active \
      .includes(:variants) \
      .includes(:images) \
      .where(id: params[:id]).first

    if @product.blank? || !@product.available
      redirect_to products_path
    end
  end

end