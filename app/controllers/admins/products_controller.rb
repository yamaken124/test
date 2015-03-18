class Admins::ProductsController < Admins::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_reef_taxons, only: [:new, :edit]

  def index
    @products = Product.includes(:products_taxons)
    @taxons = Taxon.all
  end

  def show
    @taxons = Taxon.where(id: ProductsTaxon.where(product_id: @product.id).pluck(:taxon_id))
  end

  def new
    @product = Product.new
    @product.products_taxons.build
  end

  def edit
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        raise if invalid_products_taxons_attributes?
        @product.update!(attributes_params)
      end
      redirect_to admins_product_path(params[:id])
    rescue
      @product.products_taxons.build
      render :edit
    end
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        raise if invalid_products_taxons_attributes?
        @product = Product.new(attributes_params)
        @product.save!
      end
      redirect_to admins_product_path(id: @product.id)
    rescue
      @product.products_taxons.build
      render :new
    end
  end

  def destroy
    @product.update(is_invalid_at: Time.now-1)
    redirect_to admins_products_path
  end

  private

    def attributes_params
      products_taxons_attributes = ProductsTaxon.set_valid_products_taxon_attributes(params)
      if params[:new_taxon_id].present?
        ProductsTaxon.create_new_category(@product,params)
      end
      attributes = params.require(:product).permit(:name, :description, :is_valid_at, :is_invalid_at)
      attributes = attributes.merge(products_taxons_attributes)
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def invalid_products_taxons_attributes?
      attributes_params[:products_taxons_attributes].blank?
    end

    def set_reef_taxons
      @reef_taxons = Taxon.reef_taxons
    end

end
