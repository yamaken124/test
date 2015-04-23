class ProductDescription < ActiveRecord::Base

  belongs_to :product

  validates :description, :nutritionist_explanation, :nutritionist_word, presence: true


end
