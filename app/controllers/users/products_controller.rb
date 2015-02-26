class Users::ProductsController < Users::BaseController
  def index
    @products = Product \
      .includes(:variants) \
      .includes(:prices) \
      .page(params[:page])
  end

  def show
    @product = Product \
      .includes(:variants) \
      .includes(:prices) \
      .includes(:images) \
      .where(id: params[:id]).first
  end
end