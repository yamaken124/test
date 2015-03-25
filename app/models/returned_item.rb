class ReturnedItem < ActiveRecord::Base

  validates :single_line_item_id, :user_id, :message, presence: true

end
