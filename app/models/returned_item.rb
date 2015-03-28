# == Schema Information
#
# Table name: returned_items
#
#  id                  :integer          not null, primary key
#  single_line_item_id :integer          not null
#  user_id             :integer          not null
#  message             :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ReturnedItem < ActiveRecord::Base

  belongs_to :single_line_item
  belongs_to :user

  validates :single_line_item_id, :user_id, :message, presence: true

  validates :single_line_item_id,
  uniqueness: {
    scope: [:user_id]
  }

end
