class Profile < ActiveRecord::Base

  include UserInfo

  belongs_to :user

  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :phone, presence: true, on: [:update, :preceed_to_payment]
end
