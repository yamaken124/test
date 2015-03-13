class Users::AddressesController < Users::BaseController
  before_action :set_user
  before_action :set_continue, only: [:new]

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
    if @address.save
      redirect_to continue_path
    else
      render :edit
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

    def address_params
      if Address.where(user_id: @user.id).size == 0
        params.require(:address).permit(:last_name, :first_name, :zipcode, :address, :city, :phone).merge(user_id: @user.id, default: true)
      else
        params.require(:address).permit(:last_name, :first_name, :zipcode, :address, :city, :phone).merge(user_id: @user.id)
      end
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
