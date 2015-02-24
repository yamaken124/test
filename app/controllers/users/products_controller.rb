class Users::ProductsController < Users::BaseController
  def index
    @products = Product \
      .includes({:variants => :prices}) \
      .page(params[:page])
  end

  def show
    @product = Product.where(id: params[:id]).first
  end
end
