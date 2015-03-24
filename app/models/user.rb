# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  include User::FincApp

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :purchase_orders
  has_many :addresses
  has_one  :profile
  has_many :oauth_access_tokens

  accepts_nested_attributes_for :profile

  def name
    #TODO
    "name1"
  end

  def last_incomplete_order
    purchase_orders.incomplete.order('created_at DESC').first
  end

  def wellness_mileage
    return 0 # TODO

    if total_points = me_in_finc_app['total_points']
      total_points.to_i - self.used_point_total
    else
      0
    end
  end

end
