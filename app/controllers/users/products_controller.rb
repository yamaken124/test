class Users::ProductsController < Users::BaseController
  def index
      @products = Product \
      .valid \
      .where(id: Variant.valid.pluck(:product_id)) \
      .page(params[:page]) \
      .includes(:prices) \
      .includes(:images) \
  end

  def show
    @product = Product \
      .valid \
      .includes(:variants) \
      .includes(:images) \
      .where(id: params[:id]).first
  end
end