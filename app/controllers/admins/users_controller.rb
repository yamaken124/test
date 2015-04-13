class Admins::UsersController < Admins::BaseController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.includes(:profile).page(params[:page])
    @user = User.new
  end

  def edit
  end

  def update
    num = (-1) * (params[:points]).to_i
    if @user.update_used_point_total(num)
      flash[:notice] = "マイルを#{params[:points]}増加させました"
    else
      flash[:notice] = "マイルの変更に失敗しました"
    end
    redirect_to :back
  end

  def search
    @users = User.includes(:profile).where(id: Profile.where("concat(last_name, first_name) like?", "%#{params[:name]}%").pluck(:user_id)).page(params[:page])
    flash[:notice] = '該当するユーザーはいません' if @users.empty?
    render action: 'index'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

end
