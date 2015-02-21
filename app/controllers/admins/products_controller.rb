class Admins::ProductsController < ApplicationController
  layout "admins/admins"
  def index
    @products = Product.all
  end

  def show
    @product = Product.includes(:variants)
      .find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @product = Product.new(product_params)
        @product.save!
        variant = @product.variants.build(variant_params)
        variant.save!
        price = variant.prices.build(price_params)
        price.save!
      end
      redirect_to admins_products_path
    rescue
      render :new
    end
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :is_valid_at, :is_invalid_at)
    end

    def variant_params
      params[:product].require(:variants).permit(:sku, :is_valid_at, :is_invalid_at, :order_type)
    end

    def price_params
      params[:product].require(:prices).permit(:amount)
    end
end
