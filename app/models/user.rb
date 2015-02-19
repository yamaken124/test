class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :purchase_orders
  has_many :addresses

  def last_incomplete_order
    purchase_orders.incomplete.order('created_at DESC').first
  end
end
