class ReturnedItem < ActiveRecord::Base

  belongs_to :single_line_item
  belongs_to :user

  validates :single_line_item_id, :user_id, :message, presence: true

end
