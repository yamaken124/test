class Users::ProfilesController < Users::BaseController
  before_action :set_user
  before_action :set_continue, only: [:edit]

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      continue_path
    else
      render :edit
    end
  end

  def update
    @profile = Profile.where(user_id: @user.id).first
    if @profile.present? && @profile.update(profile_params)
      redirect_to account_path
    else
      render :edit
    end
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

    def set_continue
      if params[:continue].present?
        @continue = params[:continue]
      else
        @continue = edit_profile_path
      end
    end

    def continue_path
      redirect_to edit_profile_path and return if params[:continue].blank?
      if params[:continue].present? && params[:continue].include?("credit_cards")
        redirect_to new_profile_credit_card_path
      else # params[:continue].include?("account")
        redirect_to account_path
      end
    end

end
