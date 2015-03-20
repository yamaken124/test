class Admins::VariantsController < Admins::BaseController
  before_action :set_variant, only: [:edit, :update, :destroy]
  before_action :set_price, only: [:update]
  before_action :set_product,only: [:index,:new,:edit]

  def index
    @variants = Variant.includes(:price) \
      .where(product_id: params[:product_id] )
  end

  def new
    @variant = Variant.new(product_id: params[:product_id])
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @variant = Variant.new(variant_params)
        @variant.save!
        price = Price.new(price_params)
        price.save!
      end
      redirect_to admins_product_variants_path(product_id: params[:product_id])
    rescue
      @product = Product.find(@variant.product_id)
      render :new
    end
  end

  def edit
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @variant.update!(variant_params)
        @price.update!(price_params)
      end
      redirect_to admins_product_variants_path
    rescue
      @product = Product.find(@variant.product_id)
      render :edit
    end
  end

  def destroy
    @variant.update(is_invalid_at: Time.now-1)
    redirect_to admins_product_variants_path
  end

  private
    def variant_params
      params.require(:variant).permit(:is_valid_at, :is_invalid_at, :order_type, :sku, :name).merge(product_id: params[:product_id])
    end

    def set_variant
      @variant = Variant.find(params[:id])
    end

    def set_price
      @price = Price.find_or_initialize_by( variant_id: params[:id] )
    end

    def price_params
      params.require(:variant).require(:price).permit(:amount).merge(variant_id: @variant.id)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end
end
