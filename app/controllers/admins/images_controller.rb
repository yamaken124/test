class Admins::ImagesController < Admins::BaseController
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :set_imageable, only: [:show, :edit, :new, :index]

  def index
    @images = Image.includes(imageable_model).where(images: {imageable_id: params[imageable_key]}).order("position ASC")
  end

  def new
    @image = Image.new(imageable_id: params[imageable_key])
    @images = @imageable.images
    VariantImageWhereabout.whereabouts.size.times { @image.variant_image_whereabouts.build }
  end

  def create
    @image = Image.new(image_attributes)
    if @image.save
      redirect_to admins_variant_images_path
    else
      render :new
    end
  end

  def edit
    @images = @imageable.images
  end

  def update
    if @image.update(image_params)
      redirect_to admins_variant_images_path
    else
      render :edit
    end
  end

  def destroy
    if @image.variant.images.count == 1
      flash[:notice] = "販売期間中の商品の画像を0枚にすることはできません"
      redirect_to :back
    else
      @image.destroy
      @image.variant_image_whereabouts.each {|w| w.destroy}
      redirect_to admins_variant_images_path
    end
  end

  def sort
    if Variant.find(params[:variant_id]).images.map{ |image| image.update!(position: params[:"#{image.id}"]) }
      flash[:notice] = "画像順を変更しました"
    else
      flash[:notice] = "画像順の変更に失敗しました。"
    end
    redirect_to :back
  end

  private

    def imageable_model
      imageable_type.underscore.to_sym
    end

    def check_variant_image_whereabouts_attribute
    end

    def image_attributes
      attributes = { variant_image_whereabouts_attributes: {} }
      attributes = image_params
      attributes[:variant_image_whereabouts_attributes] = valid_whereabout_from_params
      attributes
    end

    def image_params
      params.require(:image).permit(:image, :position).merge(imageable_id: params[imageable_key], imageable_type: imageable_type)
    end

    def valid_whereabout_from_params
      variant_image_whereabouts_attributes[:variant_image_whereabouts_attributes].select { |k,v| (v.values & VariantImageWhereabout.whereabouts.keys).present? }
    end

    def variant_image_whereabouts_attributes
      params.require(:image).permit(variant_image_whereabouts_attributes: [:whereabout, :variant_id])
    end

    def imageable_type
      params[:imageable_type].to_s
    end

    def imageable_key
      (imageable_type.underscore + '_id').to_sym
    end

    def imageable_class
      imageable_type.constantize
    end

    def set_image
      @image = Image.find(params[:id])
    end

    def set_imageable
      @imageable = imageable_class.find(params[imageable_key])
    end

end
