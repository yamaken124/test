# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Product < ActiveRecord::Base
  has_many :variants
  has_many :prices, :through => :variants
  has_many :images, :through => :variants
  paginates_per 5
  validates :name, presence: true

  def self.valid
    self.where('is_invalid_at > ? AND is_valid_at < ?', Time.now, Time.now)
  end

  def self.with_images
    self.where(variant.id = 1)
  end

end
