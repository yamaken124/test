class Admins::ProductsController < ApplicationController
  before_action :set_product, only: [:update,:destroy]
  layout "admins/admins"

  def index
    @products = Product.valid
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    if @product.update(product_params)
      redirect_to edit_admins_product_path(params[:id])
    else
      render :edit
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_admins_product_path(id: @product.id)
    else
      render :new
    end
  end

  def destroy
    @product.update(is_invalid_at: Time.now)
    redirect_to admins_products_path
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :is_valid_at, :is_invalid_at)
    end

    def set_product
      @product = Product.find(params[:id])
    end

end