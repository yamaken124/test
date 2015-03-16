class Users::AddressesController < Users::BaseController
  before_action :set_user
  before_action :set_continue, only: [:new]
  before_action :set_is_main, only: [:create, :update]

  def index
    @addresses = Address.where(user_id: @user.id)
  end

  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(address_params)
    if !Address.reach_upper_limit?(current_user)
      if @address.save
        redirect_to continue_path
      else
        render :edit
      end
    else
      redirect_to account_addresses_path
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to account_addresses_path
    else
      render :edit
    end
  end

  def delete
    Address.where(id: params[:id]).destroy_all
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end

    def set_is_main
      if params[:address] && params[:address][:is_main]
        @address_is_main = true
        Address.update_exist_address_false(@user)
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
      if params[:continue].present?
        @continue = params[:continue]
      else
        @continue = account_addresses_path
      end
    end

    def continue_path
      if params[:continue].include?("checkout/payment")
        checkout_state_path("payment")
      elsif params[:continue].include?("profile/credit_cards/new")
        new_profile_credit_card_path
      else
        account_addresses_path
      end
    end

end
