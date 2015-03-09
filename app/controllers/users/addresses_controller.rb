class Users::AddressesController < Users::BaseController
  before_action :set_user

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
    @referer = referer_params[:referer]
    if @address.save
      if @referer.include?("checkout/payment")
        redirect_to checkout_state_path("payment")
      else
        redirect_to account_addresses_path
      end
    else
      render :edit
    end
  end

  def update
    @address = Address.find(params[:id])
    if back_to.include?("checkout/payment")
      an
    end
    vw

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
      params.require(:address).permit(:last_name, :first_name, :zipcode, :address, :city, :phone).merge(user_id: @user.id)
    end

    def referer_params
      params.permit(:referer)
    end
end
