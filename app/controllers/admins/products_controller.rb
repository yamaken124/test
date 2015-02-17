class Admins::ProductsController < ApplicationController

def new
  @product = Product.new
end

def create
  product = Product.new(product_params)
  product.save
  variant = product.variant.build(variant_params)
  variant.save
  price = variant.price.build(price_params)
  price.save

  redirect_to new_admins_product_path
end

  def product_params
    params.require(:product).permit(:name, :description, :is_valid_at, :is_invalid_at)
  end

  def variant_params
    params[:product].require(:variants).permit(:sku, :is_valid_at, :is_invalid_at)
  end

  def price_params
    params[:product].require(:prices).permit(:amount)
  end

end