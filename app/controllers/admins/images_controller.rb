class Admins::ImagesController < Admins::BaseController
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :set_imageable, only: [:show, :edit, :new, :index]

  def index
    @images = Image.includes(imageable_model).where(images: {imageable_id: params[imageable_key]})
  end

  def new
    @image = Image.new(imageable_id: params[imageable_key])
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to admins_variant_images_path
    else
      render :new
    end
  end

  def edit
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
      redirect_to admins_variant_images_path
    end
  end

  def sort
    image = Image.find(params[:image_id])
    image.update(image_params)
    render nothing: true
  end

  private

    def imageable_model
      imageable_type.underscore.to_sym
    end

    def image_params
      params.require(:image).permit(:image, :row_order_position) \
        .merge(imageable_id: params[imageable_key], imageable_type: imageable_type)
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
