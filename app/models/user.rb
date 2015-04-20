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

  accepts_nested_attributes_for :profile

  def name
    #TODO
    "name1"
  end

  def last_incomplete_order
    purchase_orders.incomplete.order('created_at DESC').first
  end

  def wellness_mileage

    user = me_in_finc_app

    return 0 if user.blank?

    user_id     = user['id'].to_i
    start_date  = Date.parse(user['start_date'])
    total_points = user['total_points'].to_i

    # 2015-08-01以降はtotal_points - used_point_totalのみ
    return total_points - used_point_total if Date.today >= Date.new(2015, 8, 1)

    # LMとABCは先駆けてFiNC Storeをオープン
    if user_id.in?(User.lmi_user_ids)
      total_points - used_point_total
    elsif user_id.in?(User.abc_user_ids)
      total_points - used_point_total

      # 4/13にFiNC Store 全体公開
      # 公開前にプログラムをスタートしたユーザは
      # 卒業していれば
      # 総獲得ポイント - 換金したポイント(used_point)
      # ポイント換金をしていなければ卒業後に獲得したポイントを表示
      # 卒業していなければ0マイル
    elsif Date.new(2015, 2, 11) <= start_date && start_date < Date.new(2015, 4, 13)
      # 卒業しているユーザは卒業日からのポイントを起算
      if user['graduates_on'].presence
        # タスクポイントを他のポイントへ変換済のユーザはその分のポイントを失効しているので、残りポイント = total_points
        if user_id.in?(User.convert_task_points_into_other_points_user_ids)
          total_points - used_point_total

          # タスクポイントを他のポイントに変換していないユーザは卒業後のポイントを計算
        else
          user['after_graduate_points'].to_i - used_point_total
        end
      else
        0
      end
    else
      total_points - used_point_total
    end
  end

  def update_used_point_total(changed_point)
    self.used_point_total += changed_point.to_i
    save!
    UserPointHistory.create!(
      user_id: id,
      used_point: changed_point
    ) #point history
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

end
