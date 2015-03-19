class Admins::ProductsController < Admins::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_leaf_taxons, only: [:new, :edit]
  before_action :set_new_product, only: [:new]

  def index
    @products = Product.includes(:products_taxons)
    @taxons = Taxon.all
  end

  def show
    @taxons = Taxon.where(id: ProductsTaxon.where(product_id: @product.id).pluck(:taxon_id))
  end

  def new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        raise if ProductsTaxon.without_products_taxon?(params)
        @product = Product.new(attribute_params)
        @product.save!
      end
      redirect_to admins_product_path(id: @product.id)
    rescue
      set_new_product
      set_leaf_taxons
      render :new
    end
  end

  def edit
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        raise if invalid_products_taxons_attributes?(attribute_params)
        ProductsTaxon.create_products_taxon(params)
        @product.update!(attribute_params)
      end
      redirect_to admins_product_path(params[:id])
    rescue
      set_leaf_taxons
      render :edit
    end
  end

  def destroy
    @product.update(is_invalid_at: Time.now-1)
    redirect_to admins_products_path
  end

  private

    def attribute_params
      return @attribute_params if @attribute_params
      products_taxons_attributes = ProductsTaxon.set_products_taxons_attributes(params)
      attributes = params.require(:product).permit(:name, :description, :is_valid_at, :is_invalid_at)
      @attribute_params = attributes.merge(products_taxons_attributes)
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def invalid_products_taxons_attributes?(attribute_params)
      attribute_params[:products_taxons_attributes].blank?
    end

    def set_leaf_taxons
      @leaf_taxons = Taxon.leaf_taxons
    end

    def set_new_product
      @product = Product.new
      @product.products_taxons.build
    end

end
