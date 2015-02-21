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
    if @address.save
      redirect_to account_addresses_path 
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
      params.require(:address).permit(:last_name, :first_name, :zipcode, :address, :city, :phone).merge(user_id: @user.id)
    end
end
