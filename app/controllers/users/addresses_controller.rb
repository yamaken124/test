class Users::AddressesController < Users::BaseController
  before_action :set_user
  before_action :set_continue, only: [:new]
  before_action :set_is_main, only: [:create, :update]

  def index
    @addresses = @user.addresses.active
  end

  def new
    @address = Address.new
    @last_name = current_user.try(:profile).try(:last_name)
    @first_name = current_user.try(:profile).try(:first_name)
  end

  def edit
    @address = @user.addresses.find(params[:id])
    @last_name = @address.last_name
    @first_name = @address.first_name
  end

  def create
    @address = Address.new(address_params)
    if !Address.reach_upper_limit?(current_user)
      if @address.save
        continue_path
      else
        set_continue
        render :edit
      end
    else
      redirect_to account_addresses_path
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update(address_params)
      redirect_to account_addresses_path
    else
      set_continue
      render :edit
    end
  end

  def destroy
    address = @user.addresses.find(params[:id])
    address.update(deleted_at: Time.now)
    redirect_to account_addresses_path
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end

    def set_is_main
      if params[:address] && params[:address][:is_main]
        @address_is_main = true
        Address.update_all_not_main(@user)
      elsif Address.where(user_id: @user.id).count == 0
        @address_is_main = true
      else
        @address_is_main = false
      end
    end

    def address_params
      params.require(:address).permit(:last_name, :first_name, :zipcode, :address, :city, :phone).merge(user_id: @user.id, is_main: @address_is_main)
    end

    def set_continue
      @continue = params[:continue] if params[:continue].present?
    end

    def continue_path
      redirect_to account_addresses_path and return if params[:continue].blank?
      if params[:continue].include?("checkout/payment")
        redirect_to checkout_state_path("payment")
      else # params[:continue].include?("profile/credit_cards/new")
        redirect_to new_profile_credit_card_path
      end
    end

end
