class Admins::UsersController < Admins::BaseController

  include Admins::AuthenticationHelper

  before_action :allow_only_admins
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.includes(:profile).page(params[:page])
  end

  def show
    if params[:admin_name]
      begin
        ActiveRecord::Base.transaction do
          @me = @user.me_in_finc_app
        end
      rescue
        params[:admin_not_found] = "アプリ情報が見つかりません"
      end
    end
  end

  def edit
  end

  def update
    points = (-1) * (params[:points]).to_i
    if @user.update_used_point_total(points) && points != 0
      flash[:notice] = "マイルを#{params[:points]}増加させました"
    else
      flash[:notice] = "マイルの変更に失敗しました"
    end
    redirect_to :back
  end

  def search
    @users = User.includes(:profile).where(id: Profile.where("concat(last_name, first_name) like?", "%#{params[:name]}%").pluck(:user_id)).page(params[:page])
    flash[:notice] = @users.present? ? '' : '該当するユーザーはいません'
    render action: 'index'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

end
