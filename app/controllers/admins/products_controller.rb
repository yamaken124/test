class Admins::ProductsController < Admins::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_leaf_taxons, only: [:new, :edit]
  before_action :set_new_product, only: [:new]

  def index
    @displayed_products = Product.where(id: Product.available.ids ).page(params[:page])
    @products = Product.includes([:taxons, :product_description])
  end

  def show
    @taxons = Taxon.where(id: ProductsTaxon.where(product_id: @product.id).pluck(:taxon_id))
  end

  def new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        raise if without_products_taxon?
        @product = Product.new(attribute_params)
        @product.save!
      end
      redirect_to admins_product_variants_path(product_id: @product.id)
      flash[:notice] = "#{@product.name}が保存されました"
    rescue
      set_new_product
      set_leaf_taxons
      render :new
    end
  end

  def edit
    build_how_to_use_product
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        raise if invalid_products_taxons_attributes?(attribute_params)
        ProductsTaxon.create_products_taxon(params[:id],params[:new_taxon_id])
        @product.update!(attribute_params)
      end
      redirect_to admins_product_path(params[:id])
    rescue
      set_new_product
      set_leaf_taxons
      render :edit
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @product.update(is_invalid_at: Time.now-1)
      @product.variants.update_all(is_invalid_at: Time.now-1)
    end
    redirect_to admins_products_path
  end

  private
    def attribute_params
      return @attribute_params if @attribute_params.present?
      attributes = params.require(:product).permit(:name, :is_valid_at, :is_invalid_at)
      @attribute_params = attributes.merge(ProductsTaxon.products_taxons_attributes(params)).merge(product_description_attributes).merge(how_to_use_products_attributes)
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def invalid_products_taxons_attributes?(attribute_params)
      attribute_params[:products_taxons_attributes].blank?
    end

    def set_leaf_taxons
      @leaf_taxons = Taxon.leaves
    end

    def set_new_product
      @product ||= Product.new
      @product.products_taxons.build
      build_how_to_use_product
    end

    def build_how_to_use_product
      3.times { @product.how_to_use_products.build } if @product.how_to_use_products.blank?
    end

    def without_products_taxon?
      params[:product][:products_taxons_attributes]["0"][:taxon_id].blank?
    end

    def product_description_attributes
      product_description_params = {}
      product_description_params[:product_description_attributes] = params[:product].require(:product_descriptions).permit(:description, :nutritionist_explanation, :nutritionist_word)
      product_description_params
    end

    def how_to_use_products_attributes
      HowToUseProduct.attributes_for_product(params)
    end

end
