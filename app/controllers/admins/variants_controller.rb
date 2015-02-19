class Admins::VariantsController < ApplicationController
  before_action :set_variant, only: [:update]

  def index
    @variant = Variant.includes(:prices) \
      .where(product_id: params[:product_id])
  end

  def new
    @variant = Variant.new(product_id: params[:product_id])
  end

  def create
    @variant = Variant.new(variant_params)
    if @variant.save
      redirect_to admins_product_variants_path(product_id: params[:product_id])
    else
      render :new
    end
  end

  def edit
    @variant = Variant.find(params[:id])
  end

  def update
    @variant.update(variant_params)
    redirect_to admins_product_variants_path
  end

  private
    def variant_params
      params.require(:variant).permit(:sku, :is_valid_at, :is_invalid_at, :order_type).merge(product_id: params[:product_id])
    end

    def set_variant
      @variant = Variant.find(params[:id])
    end

end