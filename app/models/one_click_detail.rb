class OneClickDetail < ActiveRecord::Base

  belongs_to :address
  has_one :one_click_item
  has_one :one_click_payment

  accepts_nested_attributes_for :one_click_item
  accepts_nested_attributes_for :one_click_payment, update_only: false

end
