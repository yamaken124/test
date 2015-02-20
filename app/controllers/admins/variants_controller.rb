class Admins::VariantsController < ApplicationController
  before_action :prepare_update, only: [:update]
  layout "admins/admins"

  def index
    @variant = Variant.includes(:prices) \
      .where(product_id: params[:product_id] ).valid #\
      # .where( "is_valid_at <= ? AND is_invalid_at >= ?", Date.today, Date.today )
  end

  def new
    @variant = Variant.new(product_id: params[:product_id])
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @variant = Variant.new(variant_params)
        @variant.save!
        price = @variant.prices.build(price_params)
        price.save!
    end
      redirect_to admins_product_variants_path(product_id: params[:product_id])
    rescue
      render :new
    end
  end

  def edit
    @variant = Variant.find(params[:id])
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @variant.update!(variant_params)
        @price.update!(price_params)
      end
      redirect_to admins_product_variants_path
      rescue
        render :edit
      end
  end

  private
    def variant_params
      params.require(:variant).permit(:sku, :is_valid_at, :is_invalid_at, :order_type).merge(product_id: params[:product_id])
    end

    def prepare_update
      @variant = Variant.find(params[:id])
      @price = Price.find_or_initialize_by( variant_id: params[:id] )
    end

    def price_params
      params[:variant].require(:prices).permit(:amount)
    end

end