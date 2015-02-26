class Users::ProfilesController < Users::BaseController
  before_action :set_user

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to edit_profile_path
    else
      render :edit
    end
  end

  def update
    @profile = Profile.where(user_id: @user.id).first
    @profile.update(profile_params) unless @profile.blank?
    render :edit
  end

  def edit
    @user = User.find(current_user.id)
    @profile = Profile.where(user_id: @user.id).blank? ? Profile.new : Profile.where(user_id: @user.id).first
  end

  private 
    def set_user
      @user = User.find(current_user.id)
    end

    def profile_params
      params.require(:profile).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :phone).merge(user_id: @user.id)
    end
end
