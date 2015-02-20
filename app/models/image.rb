class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  mount_uploader :image, ImageUploader

  #explicitly define for eager loading
  belongs_to :variant, foreign_key: 'imageable_id', foreign_type: "images.imageable_type = '1'"

  enum imageable_type: {Variant: 1}
end
