class UpperUsedPointLimit < ActiveRecord::Base

  belongs_to :variant

  validates :limit, presence: true

end
