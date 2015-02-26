class Users::ProductsController < Users::BaseController
  def index
    @products = Product \
      .includes(:variants) \
      .includes(:prices) \
      .includes(:images) \
      .page(params[:page]) \
      .valid
  end

  def show
    @product = Product \
      .includes(:variants) \
      .includes(:prices) \
      .includes(:images) \
      .valid \
      .where(id: params[:id]).first
  end
end