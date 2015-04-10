class Admins::UsersController < Admins::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:profile)
  end

end
