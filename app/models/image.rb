# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_id   :integer
#  imageable_type :string(255)
#  image          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Image < ActiveRecord::Base

  belongs_to :imageable, :polymorphic => true
  mount_uploader :image, ImageUploader

  belongs_to :variant, foreign_key: 'imageable_id', foreign_type: "images.imageable_type = 'Variant"
  has_many :variant_image_whereabouts
  validates :image, :presence => true
  # validates :position, :presence => true,  :uniqueness => true
  accepts_nested_attributes_for :variant_image_whereabouts

end
