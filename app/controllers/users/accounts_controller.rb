class Users::AccountsController < Users::BaseController

  def index
    @product = Product.find(17)
    @taxons = Taxon.leaves.where.not(id: 8) #todo 見せれるやつ
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

  def show
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

  def edit
  end

end
