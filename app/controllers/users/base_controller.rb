class Users::BaseController < ApplicationController
  include Users::OrdersHelper
  before_action :authenticate_user!
  before_action :set_user
  layout "users/users"

  def set_user
    @user = current_user
    @order = current_order
  end
end
