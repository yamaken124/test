class Users::ProductsController < Users::BaseController
  def index
    available_variant_id = Image.pluck(:imageable_id) & (Price.pluck(:variant_id))
    available_id = Variant.where(id: available_variant_id).pluck(:product_id).uniq

    @products = Product \
      .where(id: available_id) \
      .valid \
      .where(id: Variant.valid.pluck(:product_id)) \
      .page(params[:page]) \
      .includes(:images)
  end

  def show
    @product = Product \
      .valid \
      .includes(:variants) \
      .includes(:images) \
      .where(id: params[:id]).first

    if @product.blank? || !@product.available
      redirect_to products_path
    end
  end

end