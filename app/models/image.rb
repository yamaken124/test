class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  mount_uploader :image, ImageUploader

  belongs_to :variant, foreign_key: 'imageable_id', foreign_type: "images.imageable_type = 'Variant"

end
