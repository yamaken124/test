class Admins::VariantsController < ApplicationController

  def new
    @variant = Variant.new(product_id: params[:product_id])
  end

  def create
    @variant = Variant.new(variant_params)
    if @variant.save
      redirect_to admins_product_path(@variant.product_id)
    else
      render :new
    end
  end

  private
    def variant_params
      params.require(:variant).permit(:sku, :is_valid_at, :is_invalid_at, :order_type).merge(product_id: params[:product_id])
    end

end