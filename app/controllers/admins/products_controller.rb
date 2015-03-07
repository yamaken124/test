class Admins::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  layout "admins/admins"
  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
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
    @product.update(is_invalid_at: Time.now-1)
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
