class Admins::ImagesController < ApplicationController

  # before_action :imageable
  layout "admins/admins"

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
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.new(image_params)
    if @image.save!
      redirect_to admins_variant_images_path
    else
      render :new
    end
  end

  private

    def imageable_model
      imageable_type.underscore.to_sym
    end

    def image_params
      params.require(:image).permit(:image) \
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

    def imageable
      # @imageable ||= imageable_class.find(params[imageable_key])
    end

end 
