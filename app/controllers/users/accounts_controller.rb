class Users::AccountsController < Users::BaseController

  def show
    @taxons = Taxon.leaves.where.not(id: 8) #todo 見せれるやつ
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

  # def show
  #   @me = current_user
  #   @wellness_mileage = @me.wellness_mileage
  # end

end
