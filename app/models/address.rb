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
#  is_main           :boolean          default(FALSE), not null
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Address < ActiveRecord::Base

  include UserInfo

  belongs_to :user

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates_with AddressCountValidator, on: :create

  scope :active, -> { where(:deleted_at => nil) }

  UpperLimit = 3

  def self.reach_upper_limit?(user)
    Address.where(user_id: user.id).active.count >= UpperLimit
  end

  def self.update_all_not_main(user)
    Address.where(user_id: user.id).update_all(is_main: false)
  end

  def full_address
    "#{zipcode} #{city} #{address}"
  end

  def self.set_address_from_zipcode(code)
    address = ZipCodeJp.find(code)
  end

end
