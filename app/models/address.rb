# == Schema Information
#
# Table name: addresses
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  last_name         :string(255)
#  first_name        :string(255)
#  address           :string(255)
#  city              :string(255)
#  zipcode           :string(255)
#  phone             :string(255)
#  alternative_phone :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Address < ActiveRecord::Base
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  validates :phone, presence: true

  validates_with AddressCountValidator, on: :create

  belongs_to :user

  def reach_upper_limit?(user)
    upper_limit = 3
    Address.where(user_id: user.id).count >= upper_limit
  end

end
