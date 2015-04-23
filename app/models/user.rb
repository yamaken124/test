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
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  used_point_total       :integer          default(0), not null
#

class User < ActiveRecord::Base
  # TODO Remove on 2015-08-01
  # ポイント移行のための暫定的なmodule
  include User::TemporaryLookupUserIds

  include User::FincApp

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :purchase_orders
  has_many :addresses
  has_one  :profile
  has_many :oauth_access_tokens
  has_many :returned_items
  has_one :users_user_category

  after_create :create_user_category

  accepts_nested_attributes_for :profile

  def name
    #TODO
    "name1"
  end

  def last_incomplete_order
    purchase_orders.incomplete.order('created_at DESC').first
  end

  def update_used_point_total(changed_point)
    self.used_point_total += changed_point.to_i
    save!
    UserPointHistory.create!(
      user_id: id,
      used_point: changed_point
    ) #point history
    WellnessMileage.add(changed_point, self)
  end

  def belonging_user_category
    UsersUserCategory.where(user_id: id)
  end

  def shown_user_categories_taxon
    UserCategoriesTaxon.where(user_category_id: belonging_user_category.pluck(:user_category_id))
  end

  def shown_product_ids
    ProductsTaxon.where(taxon_id: shown_user_categories_taxon.pluck(:taxon_id)).pluck(:product_id)
  end

  def shown_taxon
    Taxon.where(id: shown_user_categories_taxon.pluck(:taxon_id))
  end

  def max_used_point(amount)
    [wellness_mileage, amount, Payment::UsedPointLimit].min
  end

  def create_user_category
    # if id.in?(lmi_user_ids)
    #   UsersUserCategory.where(user_id: user.id).first_or_create(user_category_id: 2)
    # else
    UsersUserCategory.where(user_id: id).first_or_create(user_category_id: 1)
    # end
  end

end
