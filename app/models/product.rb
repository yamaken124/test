class Product < ActiveRecord::Base
  has_many :variants
  validates :name, presence: true

  scope :valid, -> { where( "is_valid_at < ? AND is_invalid_at > ?", Time.now, Time.now ) }
end