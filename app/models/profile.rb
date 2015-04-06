# == Schema Information
#
# Table name: profiles
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  last_name       :string(255)      default(""), not null
#  first_name      :string(255)      default(""), not null
#  last_name_kana  :string(255)      default(""), not null
#  first_name_kana :string(255)      default(""), not null
#  phone           :string(255)      default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Profile < ActiveRecord::Base

  include UserInfo

  belongs_to :user

  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :phone, presence: true, on: [:update, :preceed_to_payment]
  # validates :phone, presence: true, format: { with: proc { Profile.phone_regexp } }

  def self.phone_regexp
    /\A[0-9]{10,11}\z/
  end
end
